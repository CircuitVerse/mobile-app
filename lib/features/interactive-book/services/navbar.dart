import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/api.dart';
import 'package:mobile_app/features/interactive-book/services/offline.dart';

class NavbarService {
  /// Fetches the chapter tree, preferring the network and falling back to the
  /// offline cache when the request fails.
  Future<InteractiveBookNavbarModel> getChapters() async {
    try {
      final response = await http.get(IbApi.navbar());

      if (response.statusCode == 200) {
        await OfflineLibrary.write(OfflineLibrary.navbarKey, response.body);
        return InteractiveBookNavbarModel.fromJson(jsonDecode(response.body));
      }
    } catch (_) {
      // Fall through to the cache below.
    }

    final cached = await OfflineLibrary.read(OfflineLibrary.navbarKey);
    if (cached != null) {
      return InteractiveBookNavbarModel.fromJson(jsonDecode(cached));
    }

    throw Exception("Failed to load chapters");
  }
}
