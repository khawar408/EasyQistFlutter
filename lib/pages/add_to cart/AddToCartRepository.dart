import 'dart:convert';
import 'package:easyqist/api/ApiEndpoints.dart';
import 'package:http/http.dart' as http;

class AddToCartRepository {


  Future<Map<String, dynamic>> addToCart(Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiEndpoints.add_to_cart}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> addToCartNewProduct(Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiEndpoints.add_to_cart}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }
}
