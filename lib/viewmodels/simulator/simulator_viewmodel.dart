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

    final permissions = [Permission.storage, Permission.photos];
    for (final permission in permissions) {
      if (await permission.isGranted) return true;
      if (await permission.request().isGranted) return true;
    }
    return false;
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      try {
        final picturesDir = Directory(
          '/storage/emulated/0/Pictures/CircuitVerse',
        );
        if (!await picturesDir.exists()) {
          await picturesDir.create(recursive: true);
        }
        return picturesDir;
      } catch (e) {
        // Fallback to external storage
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) return externalDir;
      }
    }

    // iOS or final fallback
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${appDir.path}/Downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  String _getFileExtension(String url, String? mimeType) {
    // Extract from URL
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

    return mimeMap[mimeType?.toLowerCase()] ?? '.png';
  }

  void download(DownloadStartRequest request) async {
    try {
      // Request permissions
      if (!await _requestStoragePermission()) {
        SnackBarUtils.showDark(
          'Permission Denied',
          'Storage permission is required to download files.',
        );
        return;
      }

      // Get download directory and generate filename
      final downloadDir = await _getDownloadDirectory();
      final extension = _getFileExtension(
        request.url.toString(),
        request.mimeType,
      );
      final fileName =
          'CircuitVerse_${DateTime.now().millisecondsSinceEpoch}$extension';

      List<int> bytes;

      if (request.url.data != null) {
        // Handle data URLs
        bytes = request.url.data!.contentAsBytes();
      } else {
        // Handle HTTP URLs
        final httpClient = HttpClient();
        try {
          final req = await httpClient.getUrl(
            Uri.parse(request.url.toString()),
          );
          if (token != null) req.headers.add('Authorization', 'Token $token');

          final res = await req.close();
          if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');

          bytes = await res.fold<List<int>>([], (a, b) => a..addAll(b));
        } finally {
          httpClient.close();
        }
      }

      if (bytes.isEmpty) throw Exception('No data received');

      debugPrint('Downloaded ${bytes.length} bytes');

      // Save file
      final file = File('${downloadDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      // Show success message
      SnackBarUtils.showDark(
        'Download Complete!',
        Platform.isAndroid
            ? 'Saved to Pictures/CircuitVerse: $fileName'
            : 'Saved to app directory: $fileName',
      );

      // Trigger media scanner for Android images
      if (Platform.isAndroid &&
          extension.toLowerCase().contains(
            RegExp(r'\.(jpg|jpeg|png|gif|webp)'),
          )) {
        try {
          const platform = MethodChannel(
            'com.example.mobile_app/media_scanner',
          );
          await platform.invokeMethod('scanFile', {'path': file.path});
        } catch (e) {
          // Media scanner error is expected if not implemented
        }
      }
    } catch (e) {
      SnackBarUtils.showDark('Download Failed', 'Error: ${e.toString()}');
    }
  }

  void clearCookies() async {
    await cookieManager.deleteAllCookies();
  }

  bool findMatchInString(String url) {
    if (url.contains('learn.circuitverse.org')) {
      Get.offNamed(IbLandingView.id);
    } else if (url.contains('sign_in')) {
      Get.offAndToNamed(LoginView.id);
    } else if (url.contains('sign_out')) {
      clearCookies();
      return true;
    }

    final components = url.split('/');
    final length = components.length;

    // Check for project edit URLs
    if (components[length - 1] == 'edit' &&
        components[length - 3] == 'projects') {
      return true;
    }

    // Check for project save/update URLs
    if (url.contains('projects') &&
        (url.contains('saved') || url.contains('updated'))) {
      return true;
    }

    // Check for groups or users URLs
    if (url.contains('groups') || url.contains('users')) {
      return true;
    }

    return false;
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
