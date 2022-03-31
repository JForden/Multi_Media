import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Songs {
  List<dynamic> songs;

  Songs({required this.songs});

  factory Songs.fromJson(Map<String, dynamic> json) {
    return Songs(songs: json['songs']);
  }
}

class SongInfo {
  String songName;
  String artistName;
  String albumName;
  String dj = "Example DJ";
  int lastPlayed;
  String imageUrl;
  String artistSpotifyID;
  String songSpotifyID;

  SongInfo(
      {required this.songName,
      required this.artistName,
      required this.albumName,
      required this.dj,
      required this.lastPlayed,
      required this.imageUrl,
      required this.artistSpotifyID,
      required this.songSpotifyID});
}

Future<Songs> fetchSongs() async {
  final response = await http.get(Uri.parse(
      'https://radio-mke-playlist-updater.herokuapp.com/playlist-history'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Songs.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load songs');
  }
}
