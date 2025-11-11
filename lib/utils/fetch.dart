import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './image_uploader.dart';

Future< Map<String, dynamic>> fetchData() async {
  try {
    print("..");
    String? url = dotenv.env['SERVER_URL'];
    print("------------------------------------------");
    print(url);
    print("------------------------------------------");

  
    print("Sending requests to: $url/get-products");

    final response = await http.get(Uri.parse('$url/get-products'));
    Map<String, dynamic> res = jsonDecode(response.body);
    print("Received response from server.");
    print(res);
    if (response.statusCode == 200) {
      print("Successful response while fetching products.");
      // If the server returns a successful response, parse the JSON data
      return res['products'] ?? [];
    } else {
      print("Errored response while fetching products.");
      // If the server response is not successful, throw an error
      throw Exception('Failed to load data');
    }
  }
  catch (e) {
    print("Exception caught while fetching products: $e");
    return { "code": "ERROR", "message": e.toString() };
  }
}


Future<List> fetchProductsByUser(String email) async {
  print("..");
  String? url = dotenv.env['SERVER_URL'];

  print("Sending requests to: $url/get-products-by-user");

  final response = await http.get(Uri.parse('$url/get-products-by-user?email=$email'));
  List<dynamic> res = jsonDecode(response.body);
  print("Received products by user from server.");
  print(res);

  if (response.statusCode == 200) {
    print("Successful response while fetching products.");
    // If the server returns a successful response, parse the JSON data
    return res;
  } else {
    print("Errored response while fetching products.");
    // If the server response is not successful, throw an error
    throw Exception('Failed to load data');
  }
}


Future< Map<String, dynamic>> postProduct(
  String title,
  String description,
  num price,
  String contact,
  String category,
  String posterEmail,
  List<XFile> productImages
  ) async {

  print("preparing to post..");

  final ImageUploader uploader = ImageUploader();
  
  try {
    print("Uploading images...");
    List<String> imageURLs = await uploader.uploadImages(productImages);

    String? url = dotenv.env['SERVER_URL'];
    var uri = Uri.parse('$url/post-new-product');
    print("Appending image URLs");
    Map<String, dynamic> requestBody = {
      'title': title,
      'description': description,
      'price': price.toString(),
      'contact': contact,
      'category': category,
      'posterEmail': posterEmail,
      'productImages': imageURLs,
    };

    print("Storing post in database");
    // Make the POST request
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Product posted successfully!');
      print(response.body);
      return { "message": "Post added successfully!", "product":  json.decode(response.body)['product'] };


    } else {
      print('Failed to post product. Status code: ${response.statusCode}');
      print(response.body);
      return { "message": "Error in posting product ${response.body}" };
    }
  } catch (e) {
    print('Error posting product: $e');
    return { "message": "Error in posting product $e" };
  }

}


Future<Map> loginOrSignup (String uid, String email, String name) async {
  String? url = dotenv.env['SERVER_URL'];

  final response = await http.post(
    Uri.parse('$url/loginOrSignup'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      "uid": uid,
      'email': email,
      'name': name,
    }),
  ).timeout(const Duration(seconds: 10));

  Logger print = Logger(printer: PrettyPrinter());

  if (response.statusCode == 200) {
    print.i('Signup/Login successful: ${response.body}');
    return { "code": "SUCCESS" };
  } else {
    print.w('Signup/Login failed: ${response.statusCode} - ${response.body}');
    return { "code": "FAILURE", "message": response.body };

  }
}


Future<Map> fetchNotifications () async {
  Logger print = Logger(printer: PrettyPrinter());

  String? url = dotenv.env['SERVER_URL'];
  final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
  final token = await user.getIdToken();

  print.i("Token: $token");

  final response = await http.get(
    Uri.parse('$url/notifications'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    },
  ).timeout(const Duration(seconds: 10));


  print.i("Response Status Code: ${response.statusCode}");
  print.i("Notifications Body: ${response.body}");

  if (response.statusCode == 200) {
    print.i('Fetched notifications successfully: ${response.body}');
    return json.decode(response.body);
  } else {
    print.w('Fetching notifications failed: ${response.statusCode} - ${response.body}');
    return { "code": "FAILURE", "message": response.body };

  }
}