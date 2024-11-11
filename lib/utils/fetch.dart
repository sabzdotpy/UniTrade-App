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
    return res;
  } else {
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
      'poster': poster
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