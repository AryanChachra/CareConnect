import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService{
  final String baseUrl = 'https://careconnect-web-alnz.onrender.com';

  Future<dynamic> getData(String endpoint) async{
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception('Failed to load Data!!');
    }
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async{
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(data),
    );
    // print('Data: ${data}');
    // print('Response Status: ${response.statusCode}');
    // print('Response Body: ${response.body}');
    // print('Response Headers: ${response.headers}');

    if(response.statusCode == 200 || response.statusCode == 201){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('Failed to post Data!!');
    }
  }


  Future<dynamic> putData(String endpoint, Map<String, dynamic> data) async{
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('Failed to put Data!!');
    }
  }
  
  Future<dynamic> deleteData(String endpoint) async{
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),);
    if (response.statusCode == 200){
      return;
    }
    else{
      throw Exception('Failed to Delete Data!!');
    }
  }
}