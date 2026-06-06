import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dni5tsmcg';
  static const String uploadPreset = 'taafi_unsigned';

  static Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();
    final data = json.decode(utf8.decode(await response.stream.toBytes()));
    if (response.statusCode == 200) return data['secure_url'];
    throw Exception('فشل رفع الصورة: ${data['error']['message']}');
  }

  static Future<String> uploadVideo(File videoFile) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/video/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', videoFile.path));
    final response = await request.send();
    final data = json.decode(utf8.decode(await response.stream.toBytes()));
    if (response.statusCode == 200) return data['secure_url'];
    throw Exception('فشل رفع الفيديو: ${data['error']['message']}');
  }
}
