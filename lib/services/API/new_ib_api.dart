import 'package:mobile_app/constants.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/models/ib/new_ib_home_data.dart';
import 'package:mobile_app/models/ib/new_ib_chapter_index_data.dart';
import 'package:mobile_app/services/database_service.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class NewIbApi {
  Future<NewIbDrawerData> fetchDrawerData();
  Future<NewIbHomeData> fetchHomeData();
  Future<NewIbChapterIndexData> fetchChapterIndexData(String path);
}

class HttpNewIbApi implements NewIbApi {
  final DatabaseService _db = locator<DatabaseService>();
  
  // Base URL for the new IB backend
  // Android Emulator: Use 10.0.2.2 (maps to host's localhost)
  // iOS Simulator: Use localhost or 127.0.0.1
  // Physical Device: Use your computer's IP (e.g., 192.168.1.100)
  static const String BASE_URL = String.fromEnvironment(
    'NEW_IB_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
  static const String DRAWER_URL = '$BASE_URL/drawer.json';
  static const String HOME_URL = '$BASE_URL/pages/index.json';
  
  @override
  Future<NewIbDrawerData> fetchDrawerData() async {
    try {
      // Check cache first
      if (await _db.isExpired(DRAWER_URL)) {
        // Fetch from API
        final jsonResponse = await ApiUtils.get(DRAWER_URL);
        
        // Cache the response
        await _db.setData(
          DatabaseBox.IB,
          DRAWER_URL,
          jsonResponse,
          expireData: true,
        );
        
        return NewIbDrawerData.fromJson(jsonResponse as Map<String, dynamic>);
      } else {
        // Return cached data
        final dynamic rawData = await _db.getData(
          DatabaseBox.IB,
          DRAWER_URL,
        );
        
        // Cast to proper type
        final Map<String, dynamic> properData = Map<String, dynamic>.from(rawData as Map);
        
        return NewIbDrawerData.fromJson(properData);
      }
    } on FormatException catch (e) {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception catch (e) {
      throw Failure('Failed to fetch drawer data: ${e.toString()}');
    }
  }

  @override
  Future<NewIbHomeData> fetchHomeData() async {
    try {
      // Check cache first
      if (await _db.isExpired(HOME_URL)) {
        // Fetch from API
        final jsonResponse = await ApiUtils.get(HOME_URL);
        
        // Cache the response
        await _db.setData(
          DatabaseBox.IB,
          HOME_URL,
          jsonResponse,
          expireData: true,
        );
        
        return NewIbHomeData.fromJson(jsonResponse as Map<String, dynamic>);
      } else {
        // Return cached data
        final dynamic rawData = await _db.getData(
          DatabaseBox.IB,
          HOME_URL,
        );
        
        // Cast to proper type
        final Map<String, dynamic> properData = Map<String, dynamic>.from(rawData as Map);
        
        return NewIbHomeData.fromJson(properData);
      }
    } on FormatException catch (e) {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception catch (e) {
      throw Failure('Failed to fetch home data: ${e.toString()}');
    }
  }

  @override
  Future<NewIbChapterIndexData> fetchChapterIndexData(String path) async {
    final url = '$BASE_URL/pages/$path/index.json';
    
    try {
      // Check cache first
      if (await _db.isExpired(url)) {
        // Fetch from API
        final jsonResponse = await ApiUtils.get(url);
        
        // Cache the response
        await _db.setData(
          DatabaseBox.IB,
          url,
          jsonResponse,
          expireData: true,
        );
        
        return NewIbChapterIndexData.fromJson(jsonResponse as Map<String, dynamic>);
      } else {
        // Return cached data
        final dynamic rawData = await _db.getData(
          DatabaseBox.IB,
          url,
        );
        
        // Cast to proper type
        final Map<String, dynamic> properData = Map<String, dynamic>.from(rawData as Map);
        
        return NewIbChapterIndexData.fromJson(properData);
      }
    } on FormatException catch (e) {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception catch (e) {
      throw Failure('Failed to fetch chapter index data: ${e.toString()}');
    }
  }
}
