import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
class IbOfflineService {

  Future<String> _getPath(String chapterId) async {
    final dir = await getApplicationDocumentsDirectory();
    String fileName = base64Url.encode(utf8.encode(chapterId));
    return "${dir.path}/ib_$fileName";
  }

  Future<void> saveChapter(String chapterId, String data) async {
    try{
      final path = await _getPath(chapterId);
      final file = File(path);
      await file.writeAsString(data);
    }
    catch(e){
      print("Offline save error: $e");
    }
  }

  Future<String?> loadChapter(String chapterId) async {
    try{
      final path = await _getPath(chapterId);
      final file = File(path);  
      if (await file.exists()) {
        return await file.readAsString();
      }
    }
    catch(e){
      print("Offline load error: $e");
    }
    return null;
  }

  Future<bool> isDownloaded(String chapterId) async {
    final path = await _getPath(chapterId);
    return File(path).exists();
  }
  
}