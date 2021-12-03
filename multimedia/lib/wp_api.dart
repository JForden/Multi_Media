import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> getData() async {
  String url = "https://radiomilwaukee.org/wp-json/wp/v2/story?_embed";
  final response = await http.get(Uri.parse(url), headers: {
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
