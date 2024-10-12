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
    // If the server returns a successful response, parse the JSON data
    return res;
  } else {
    // If the server response is not successful, throw an error
    throw Exception('Failed to load data');
  }
}
