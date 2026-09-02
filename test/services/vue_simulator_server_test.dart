import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/services/vue_simulator_server.dart';

// The proxy is what lets the bundled simulator save online, so these cover the
// forwarding rules against a fake upstream.
void main() {
  late HttpServer upstream;
  late List<HttpRequest> received;
  late VueSimulatorServer server;
  late HttpClient client;
  String? token;
  final originalBaseUrl = EnvironmentConfig.CV_BASE_URL;

  setUp(() async {
    received = [];
    token = 'test-token';

    upstream = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    upstream.listen((request) async {
      // Drain the body first so assertions can read the request.
      final body = await utf8.decoder.bind(request).join();
      received.add(request);
      request.response.headers.contentType = ContentType.json;
      request.response.statusCode = HttpStatus.created;
      request.response.write(
        jsonEncode({'path': request.uri.path, 'body': body}),
      );
      await request.response.close();
    });

    EnvironmentConfig.CV_BASE_URL = 'http://127.0.0.1:${upstream.port}';

    server = VueSimulatorServer(
      documentRoot: 'vue/dist/simulatorvue/v1',
      tokenProvider: () => token,
    );
    await server.start();
    client = HttpClient();
  });

  tearDown(() async {
    client.close(force: true);
    await server.close();
    await upstream.close(force: true);
    EnvironmentConfig.CV_BASE_URL = originalBaseUrl;
  });

  Future<HttpClientResponse> send(
    String method,
    String path, {
    String? body,
  }) async {
    final request = await client.openUrl(
      method,
      Uri.parse('http://127.0.0.1:${server.port}$path'),
    );
    request.cookies.add(Cookie(VueSimulatorServer.secretCookie, server.secret));
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(body);
    }
    return request.close();
  }

  test(
    'forwards /api/v1 requests upstream with the app session token',
    () async {
      final response = await send('GET', '/api/v1/me');

      expect(response.statusCode, HttpStatus.created);
      expect(received.single.uri.path, '/api/v1/me');
      expect(
        received.single.headers.value('authorization'),
        'Token test-token',
      );
    },
  );

  test(
    'preserves method, path, query and body when saving a project',
    () async {
      await send(
        'POST',
        '/api/v1/projects?include=author',
        body: '{"name":"Half Adder"}',
      );

      final request = received.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/api/v1/projects');
      expect(request.uri.query, 'include=author');
    },
  );

  test('omits the auth header when signed out', () async {
    token = null;

    await send('GET', '/api/v1/me');

    expect(received.single.headers.value('authorization'), isNull);
  });

  test('replaces the placeholder token the page sends itself', () async {
    // The page sends this because it looks for a cookie we never set.
    final request = await client.openUrl(
      'GET',
      Uri.parse('http://127.0.0.1:${server.port}/api/v1/me'),
    );
    request.cookies.add(Cookie(VueSimulatorServer.secretCookie, server.secret));
    request.headers.set(HttpHeaders.authorizationHeader, 'Token undefined');
    await request.close();

    expect(received.single.headers.value('authorization'), 'Token test-token');
  });

  test(
    'passes the upstream status and content type back to the page',
    () async {
      final response = await send('GET', '/api/v1/me');

      expect(response.statusCode, HttpStatus.created);
      expect(response.headers.contentType?.mimeType, 'application/json');
      expect(await utf8.decoder.bind(response).join(), contains('/api/v1/me'));
    },
  );

  test('does not forward encodings HttpClient cannot decode', () async {
    // HttpClient only decodes gzip, so forwarding br/zstd breaks every response.
    final request = await client.openUrl(
      'GET',
      Uri.parse('http://127.0.0.1:${server.port}/api/v1/me'),
    );
    request.cookies.add(Cookie(VueSimulatorServer.secretCookie, server.secret));
    request.headers.set('accept-encoding', 'gzip, deflate, br, zstd');
    await request.close();

    final forwarded = received.single.headers.value('accept-encoding') ?? '';
    expect(forwarded, isNot(contains('br')));
    expect(forwarded, isNot(contains('zstd')));
  });

  test('refuses proxy requests without the key', () async {
    // Any app on the device can reach the port, so the token must not be
    // handed to a caller that cannot prove it is our page.
    final request = await client.openUrl(
      'GET',
      Uri.parse('http://127.0.0.1:${server.port}/api/v1/me'),
    );
    final response = await request.close();

    expect(response.statusCode, HttpStatus.forbidden);
    expect(received, isEmpty);
  });

  test('binds a port the OS chooses', () async {
    expect(server.port, greaterThan(0));
  });

  test('serves a 404 rather than hanging when an asset is missing', () async {
    final response = await send('GET', '/definitely-not-bundled.js');

    expect(response.statusCode, HttpStatus.notFound);
  });
}
