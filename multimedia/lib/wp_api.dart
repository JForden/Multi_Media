import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// api call to get data from wordpress rest api for 88ninemilwaukee's news page. It returns the most recent 30 news articles in json format. you can copy and paste this url into your browser to see the data.
// use firefox as it formats it better than chrome.
Future<List> getData() async {
  String url =
      "https://radiomilwaukee.org/wp-json/wp/v2/story?_embed&per_page=30";
  final response = await http.get(Uri.parse(url), headers: {
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
