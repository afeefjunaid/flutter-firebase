import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:productcatalogue/src/home/view/homeScreenView.dart';

import '../home/model/homeScreenModel.dart';

class ApiClient{
  static String baseUrl="https://fakestoreapi.com/";

  static getRequest(String Apiurl) async {
    try {
      final url = Uri.parse(baseUrl + Apiurl);
      final response = await http.get(url);
      return response;
    } catch (e) {
      throw Exception('Error: An error occurred: $e');
    }
  }

  static postRequest(String user, String Pass,BuildContext con,String Apiurl) async {
    final url = Uri.parse(baseUrl+Apiurl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': user,
        'password': Pass,
      }),
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];
      ScaffoldMessenger.of(con).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text('Login successful!')),
      );
      Navigator.pushReplacement(con, MaterialPageRoute(builder: (con)=>homeScreenView()));
    } else {
      ScaffoldMessenger.of(con).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
        content: Text('Login failed! Please check your credentials.')),
      );
    }
  }
}