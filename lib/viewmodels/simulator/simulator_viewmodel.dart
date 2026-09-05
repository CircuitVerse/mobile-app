import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SimulatorViewModel extends BaseModel {
  // ViewState Keys
  static const String SIMULATOR = 'simulator';

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

  // Project to edit
  Project? _projectToEdit;

  String get url {
    if (_projectToEdit != null) {
      return '${EnvironmentConfig.CV_BASE_URL}/simulator/edit/${_projectToEdit!.id}';
    }
    return '${EnvironmentConfig.CV_BASE_URL}/simulator';
  }

  String? get token => _service.isLoggedIn ? _service.token : null;

  Uri get uri => Uri.parse(EnvironmentConfig.CV_BASE_URL);

  void setProjectToEdit(Project? project) {
    _projectToEdit = project;
    notifyListeners();
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

  Future<void> clearCookies() async {
    await cookieManager.deleteAllCookies();
  }

  Future<String?> handleNavigation(
    String url,
    InAppWebViewController? controller,
  ) async {
    if (url.contains('learn.circuitverse.org')) {
      Get.offNamed(IbLandingView.id);
      return 'cancel';
    } else if (url.contains('sign_in')) {
      if (_service.isLoggedIn && controller != null) {
        await controller.loadUrl(
          urlRequest: URLRequest(
            url: WebUri.uri(Uri.parse(this.url)),
            headers: {'Authorization': 'Token $token'},
          ),
        );
        return 'cancel';
      } else {
        Get.offAndToNamed(LoginView.id);
        return 'cancel';
      }
    } else if (url.contains('sign_out')) {
      await clearCookies();
      Get.offAndToNamed(CVLandingView.id);
      return 'cancel';
    }
    return null;
  }

  void onModelReady([Project? project]) {
    if (project != null) {
      setProjectToEdit(project);
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void onModelDestroy() {
    _projectToEdit = null;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
