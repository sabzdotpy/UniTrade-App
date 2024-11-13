import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  final String cloudinaryUploadUrl = 'https://api.cloudinary.com/v1_1/diwf54xkb/image/upload';
  final String cloudinaryUploadPreset = 'unitrade';

  // Function to upload a single image file to Cloudinary
  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl));
      request.fields['upload_preset'] = cloudinaryUploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseData);
        return jsonResponse['secure_url'];
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to upload a list of images and return a list of URLs
  Future<List<String>> uploadImages(List<XFile> imageFiles) async {
    List<String> imageUrls = [];

    for (XFile imageFile in imageFiles) {
      final imageUrl = await uploadImage(imageFile);
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
      } else {
        print('Error uploading file: ${imageFile.name}');
      }
    }

    return imageUrls;
  }
}
