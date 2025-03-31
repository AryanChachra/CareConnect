import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService{
  final String baseUrl = 'https://careconnect-web-alnz.onrender.com';

  Future<dynamic> getData(String endpoint) async{
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      return jsonDecode(response.body);
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async{
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(data),
    );
      return jsonDecode(response.body);
  }


  Future<dynamic> putData(String endpoint, Map<String, dynamic> data) async{
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(data),
    );
      return jsonDecode(response.body);
  }
  
  Future<dynamic> deleteData(String endpoint) async{
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),);
      return;
  }
}