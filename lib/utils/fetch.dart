import 'dart:convert'; // For json decoding
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future< Map<String, dynamic>> fetchData() async {
  print("..");
  String? url = dotenv.env['SERVER_URL'];

  print("Sending requests to: $url/get-products");

  final response = await http.get(Uri.parse('$url/get-products'));
  Map<String, dynamic> res = jsonDecode(response.body);
  print("Received response from server.");
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


Future< Map<String, dynamic>> postProduct(String title, String description, num price,  String imageURL, String category, String poster ) async {

  print("..");
  String? url = dotenv.env['SERVER_URL'];

  print("Sending requests to: $url/get-products");

  final response = await http.post(
    Uri.parse('$url/post-new-product'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'description': description,
      'price': price,
      'imageURL': '', // Replace with your image URL
      'category': category,
      'posterEmail': poster
    }),
  );

  if (response.statusCode == 200) {
    print('Data sent successfully: ${response.body}');
    return { "message": "Post added successfully." };
  } else {
    print('Failed to send data: ${response.statusCode}');
    return { "message": "Post adding error." };
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
  );

  if (response.statusCode == 200) {
    print('Signup/Login successful: ${response.body}');
    return { "code": "SUCCESS" };
  } else {
    print('Signup/Login failed: ${response.statusCode} - ${response.body}');
    return { "code": "FAILURE" };
  }
}