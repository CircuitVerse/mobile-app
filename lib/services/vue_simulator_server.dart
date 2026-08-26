import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobile_app/config/environment_config.dart';

/// Local server for the bundled Vue simulator.
///
/// Serves the simulator files from the app bundle, and forwards `/api/v1`
/// requests to CircuitVerse with the user's token. Serving both from one origin
/// is what lets the Vue app save online without any changes to it.
class VueSimulatorServer {
  VueSimulatorServer({required this.documentRoot, required this.tokenProvider});

  /// Asset directory holding the bundle, without a trailing slash.
  final String documentRoot;

  /// Current session token, read per request so a login is picked up.
  final String? Function() tokenProvider;

  static const String _apiPrefix = '/api/v1';

  /// Name of the cookie guarding the proxy.
  static const String secretCookie = 'cv_sim_key';

  /// Random per launch, so other apps on the device cannot guess it.
  final String secret = _randomKey();

  HttpServer? _server;
  HttpClient? _client;

  bool get isRunning => _server != null;

  /// Assigned by the OS on [start].
  int get port => _server?.port ?? 0;

  String get url => 'http://localhost:$port/';

  Future<void> start() async {
    if (_server != null) return;

    // Port 0: let the OS pick a free one, so we never collide with another app.
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _client = HttpClient();

    unawaited(
      _server!
          .forEach(_handle)
          .catchError((Object e) => debugPrint('[vue-sim] server error: $e')),
    );
  }

  Future<void> close() async {
    _client?.close(force: true);
    _client = null;
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _handle(HttpRequest request) async {
    try {
      if (request.uri.path.startsWith(_apiPrefix)) {
        await _proxy(request);
      } else {
        await _serveAsset(request);
      }
    } catch (e) {
      debugPrint('[vue-sim] ${request.uri.path} failed: $e');
      request.response.statusCode = HttpStatus.internalServerError;
    }
    await request.response.close();
  }

  Future<void> _serveAsset(HttpRequest request) async {
    var path = request.uri.path;
    path = path.startsWith('/') ? path.substring(1) : path;
    if (path.isEmpty || path.endsWith('/')) path += 'index.html';

    final ByteData data;
    try {
      data = await rootBundle.load('$documentRoot/${Uri.decodeFull(path)}');
    } catch (_) {
      // Routine: the browser asks for /favicon.ico, and the bundle has a couple
      // of stale font references.
      request.response.statusCode = HttpStatus.notFound;
      return;
    }

    request.response.headers.contentType = _contentTypeFor(path);
    request.response.add(data.buffer.asUint8List());
  }

  Future<void> _proxy(HttpRequest request) async {
    // Any app on the device can reach a loopback port, and this endpoint
    // carries the user's token, so require the cookie only our page has.
    final hasKey = request.cookies.any(
      (c) => c.name == secretCookie && c.value == secret,
    );
    if (!hasKey) {
      debugPrint(
        '[vue-sim] rejected an unkeyed request to ${request.uri.path}',
      );
      request.response.statusCode = HttpStatus.forbidden;
      return;
    }

    final target = Uri.parse(
      '${EnvironmentConfig.CV_BASE_URL}${request.uri.path}',
    ).replace(query: request.uri.query.isEmpty ? null : request.uri.query);

    final body = await _readBody(request);
    final upstream = await _client!.openUrl(request.method, target);

    request.headers.forEach((name, values) {
      final lower = name.toLowerCase();
      // Skip headers describing the local hop, plus accept-encoding: Chromium
      // asks for brotli, which HttpClient cannot decode, and the page would
      // then fail to parse every response.
      if (lower == 'host' ||
          lower == 'content-length' ||
          lower == 'authorization' ||
          lower == 'origin' ||
          lower == 'referer' ||
          lower == 'accept-encoding') {
        return;
      }
      upstream.headers.set(name, values.join(','));
    });

    // The page sends "Token undefined" because it looks for a cookie a Flutter
    // login never sets.
    final token = tokenProvider();
    if (token != null && token.isNotEmpty) {
      upstream.headers.set(HttpHeaders.authorizationHeader, 'Token $token');
    }

    if (body.isNotEmpty) {
      upstream.headers.contentLength = body.length;
      upstream.add(body);
    }

    final response = await upstream.close();
    if (kDebugMode) {
      debugPrint(
        '[vue-sim] proxy ${request.method} ${request.uri.path} '
        '-> ${response.statusCode}${token == null ? " (signed out)" : ""}',
      );
    }

    request.response.statusCode = response.statusCode;
    final contentType = response.headers.contentType;
    if (contentType != null) {
      request.response.headers.contentType = contentType;
    }
    await response.forEach(request.response.add);
  }

  Future<List<int>> _readBody(HttpRequest request) async {
    final chunks = <int>[];
    await request.forEach(chunks.addAll);
    return chunks;
  }

  ContentType _contentTypeFor(String path) {
    final dot = path.lastIndexOf('.');
    final ext = dot == -1 ? '' : path.substring(dot + 1).toLowerCase();
    return switch (ext) {
      'html' => ContentType.html,
      'js' || 'mjs' => ContentType('text', 'javascript', charset: 'utf-8'),
      'css' => ContentType('text', 'css', charset: 'utf-8'),
      'json' => ContentType.json,
      'svg' => ContentType('image', 'svg+xml', charset: 'utf-8'),
      'png' => ContentType('image', 'png'),
      'jpg' || 'jpeg' => ContentType('image', 'jpeg'),
      'gif' => ContentType('image', 'gif'),
      'ico' => ContentType('image', 'x-icon'),
      'woff2' => ContentType('font', 'woff2'),
      'woff' => ContentType('font', 'woff'),
      'ttf' => ContentType('font', 'ttf'),
      'eot' => ContentType('application', 'vnd.ms-fontobject'),
      'wasm' => ContentType('application', 'wasm'),
      'tar' => ContentType('application', 'x-tar'),
      _ => ContentType.binary,
    };
  }
}

String _randomKey() {
  final random = Random.secure();
  return List.generate(
    24,
    (_) => random.nextInt(256),
  ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
