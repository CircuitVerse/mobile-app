import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/services/vue_simulator_server.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Runs the bundled Vue simulator (cv-frontend-vue v0) on a local server.
///
/// The bundle cannot be loaded from `file://`: it is an ES module build that
/// also spawns a worker and calls fetch, all blocked without a real origin.
class SimulatorViewModel extends BaseModel {
  // ViewState Keys
  static const String SIMULATOR = 'simulator';

  /// Built by tool/build_vue_simulator.dart, bundled via pubspec.yaml.
  static const String _documentRoot = 'vue/dist/simulatorvue/v0';

  // Services
  final LocalStorageService _service = locator<LocalStorageService>();
  final cookieManager = CookieManager.instance();

  // Method channels
  static const _mediaScannerChannel = MethodChannel(
    'com.example.mobile_app/media_scanner',
  );
  static const _mediaStoreChannel = MethodChannel(
    'com.example.mobile_app/media_store',
  );

  late final VueSimulatorServer _server = VueSimulatorServer(
    documentRoot: _documentRoot,
    tokenProvider: () => token,
  );

  /// Set once the view is gone, so a startup still in flight gives up.
  bool _destroyed = false;

  String get url => _server.url;

  String? get token => _service.isLoggedIn ? _service.token : null;

  /// Port the server bound to. Valid once it has started.
  int get port => _server.port;

  /// Project the simulator opens on load. Set before the page loads.
  set projectId(String? id) => _server.projectId = id;

  /// Looks up a project so a website link can open the app's project screen.
  Future<Project?> fetchProject(String projectId) async {
    try {
      return await locator<ProjectsApi>().getProjectDetails(projectId);
    } catch (e) {
      debugPrint('[vue-sim] could not fetch project $projectId: $e');
      return null;
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isIOS) return true;

    if (Platform.isAndroid) {
      // Simplified permission logic
      try {
        // First try to get API level
        final result = await _mediaStoreChannel.invokeMethod<int>(
          'getApiLevel',
        );
        final apiLevel = result ?? 28;
        debugPrint('Android API Level: $apiLevel');

        if (apiLevel >= 29) {
          // Android 10+: No runtime permission needed to write via MediaStore.
          return true;
        } else {
          // Android 9 and below: Need WRITE_EXTERNAL_STORAGE
          final permission = Permission.storage;
          if (await permission.isGranted) return true;
          final status = await permission.request();
          debugPrint('Storage permission status: $status');
          return status.isGranted;
        }
      } catch (e) {
        debugPrint('Error checking API level: $e');
        // Fallback: try storage permission
        final permission = Permission.storage;
        if (await permission.isGranted) return true;
        final status = await permission.request();
        debugPrint('Fallback storage permission status: $status');
        return status.isGranted;
      }
    }

    return false;
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Use app-specific external storage as a safe fallback on all API levels.
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) return externalDir;
    }

    // iOS or final fallback
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${appDir.path}/Downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  String _getFileExtension({
    required String url,
    String? mimeType,
    String? suggestedFilename,
    String? contentDisposition,
  }) {
    if (suggestedFilename?.contains('.') ?? false) {
      return suggestedFilename!.substring(suggestedFilename.lastIndexOf('.'));
    }

    if (contentDisposition != null) {
      final match = RegExp(
        r"filename\*?=(?:UTF-8'')?"
        r'"?([^";]+)"?',
        caseSensitive: false,
      ).firstMatch(contentDisposition);
      if (match != null) {
        final name = Uri.decodeFull(match.group(1)!);
        if (name.contains('.')) {
          return name.substring(name.lastIndexOf('.'));
        }
      }
    }

    final uri = Uri.parse(url);
    if (uri.path.contains('.')) {
      return uri.path.substring(uri.path.lastIndexOf('.'));
    }

    final mimeMap = {
      'image/png': '.png',
      'image/jpeg': '.jpg',
      'image/jpg': '.jpg',
      'image/gif': '.gif',
      'image/webp': '.webp',
      'image/svg+xml': '.svg',
      'application/pdf': '.pdf',
    };

    return mimeMap[mimeType?.toLowerCase()] ?? '.bin';
  }

  String _getMimeType(String extension) {
    final mimeMap = {
      '.png': 'image/png',
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.gif': 'image/gif',
      '.webp': 'image/webp',
      '.svg': 'image/svg+xml',
      '.pdf': 'application/pdf',
    };
    return mimeMap[extension.toLowerCase()] ?? 'application/octet-stream';
  }

  bool _isImageFile(String extension) {
    final imageExtensions = {'.jpg', '.jpeg', '.png', '.gif', '.webp'};
    return imageExtensions.contains(extension.toLowerCase());
  }

  Future<void> download(DownloadStartRequest request) async {
    try {
      // Request permissions
      if (!await _requestStoragePermission()) {
        SnackBarUtils.showDark(
          'Permission Denied',
          'Storage permission is required to download files.',
        );
        return;
      }

      // Get file extension and generate filename
      final extension = _getFileExtension(
        url: request.url.toString(),
        mimeType: request.mimeType,
        suggestedFilename: request.suggestedFilename,
        contentDisposition: request.contentDisposition,
      );
      final fileName =
          'CircuitVerse_${DateTime.now().millisecondsSinceEpoch}$extension';

      List<int> bytes = [];

      if (request.url.data != null) {
        // Handle data URLs
        bytes = request.url.data!.contentAsBytes();
      } else {
        // Handle HTTP URLs
        final httpClient = HttpClient();
        try {
          Uri current = Uri.parse(request.url.toString());
          for (var i = 0; i < 5; i++) {
            final req = await httpClient.getUrl(current);
            if (token != null) req.headers.add('Authorization', 'Token $token');
            final cookies = await cookieManager.getCookies(
              url: WebUri.uri(current),
            );
            if (cookies.isNotEmpty) {
              req.headers.add(
                'Cookie',
                cookies.map((c) => '${c.name}=${c.value}').join('; '),
              );
            }
            final res = await req.close();
            if (res.isRedirect && res.headers.value('location') != null) {
              current = current.resolve(res.headers.value('location')!);
              await res.drain<void>();
              continue;
            }
            if (res.statusCode != 200) {
              throw Exception('HTTP ${res.statusCode}');
            }
            bytes = await res.fold<List<int>>([], (a, b) => a..addAll(b));
            break;
          }
        } finally {
          httpClient.close();
        }
      }

      if (bytes.isEmpty) throw Exception('No data received');

      debugPrint('Downloaded ${bytes.length} bytes');

      if (Platform.isAndroid && _isImageFile(extension)) {
        try {
          final result = await _mediaStoreChannel.invokeMethod<int>(
            'getApiLevel',
          );
          final apiLevel = result ?? 28;
          debugPrint('Using MediaStore for API level: $apiLevel');

          if (apiLevel >= 29) {
            // Use MediaStore for Android 10+
            debugPrint('Attempting MediaStore save for: $fileName');
            final success = await _mediaStoreChannel
                .invokeMethod<bool>('saveToPictures', {
                  'bytes': Uint8List.fromList(bytes),
                  'filename': fileName,
                  'mimeType': _getMimeType(extension),
                });

            debugPrint('MediaStore save result: $success');
            if (success == true) {
              SnackBarUtils.showDark(
                'Download Complete!',
                'Image saved to Pictures/CircuitVerse: $fileName',
              );
              return;
            } else {
              throw Exception('MediaStore save returned false');
            }
          }
        } catch (e) {
          debugPrint(
            'MediaStore method failed, falling back to file system: $e',
          );
        }
      }

      // Legacy method for non-images or Android 9 and below
      final downloadDir = await _getDownloadDirectory();
      final file = File('${downloadDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      // Show success message
      SnackBarUtils.showDark('Download Complete!', 'Saved to: ${file.path}');

      // Trigger media scanner for Android images (legacy method)
      if (Platform.isAndroid && _isImageFile(extension)) {
        try {
          await _mediaScannerChannel.invokeMethod('scanFile', {
            'path': file.path,
          });
        } catch (e) {
          debugPrint('Media scan error: $e');
        }
      }
    } catch (e) {
      SnackBarUtils.showDark('Download Failed', 'Error: ${e.toString()}');
    }
  }

  Future<void> onModelReady([String? projectId]) async {
    setStateFor(SIMULATOR, ViewState.Busy);
    _server.projectId = projectId;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    try {
      // The bundle is not committed, and a build without it still succeeds, so
      // check before starting or the user just gets a blank webview.
      await rootBundle.load('$_documentRoot/index.html');
      await _server.start();
      // The page proves it is ours by sending this back on API calls.
      await cookieManager.setCookie(
        url: WebUri(url),
        name: VueSimulatorServer.secretCookie,
        value: _server.secret,
      );

      // Left while we were starting: shut the server we just brought up.
      if (_destroyed) return _server.close();
      setStateFor(SIMULATOR, ViewState.Idle);
    } catch (e) {
      debugPrint('[vue-sim] could not start the simulator: $e');
      if (_destroyed) return;
      setErrorMessageFor(SIMULATOR, e.toString());
      setStateFor(SIMULATOR, ViewState.Error);
    }
  }

  Future<void> onModelDestroy() async {
    _destroyed = true;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await _server.close();
  }
}
