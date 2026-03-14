import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}