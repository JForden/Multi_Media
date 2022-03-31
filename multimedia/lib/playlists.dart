import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multimedia/songs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final ScrollController _scrollController = ScrollController();
  final _searchTextController = TextEditingController();
  List<SongInfo> songInfoList = [];
  List<SongInfo> searchResults = [];
  late Future<Songs> futureSongs;
  List<dynamic> songInfoListFuture = [];
  bool allLoaded = false;
  bool isHover = false;
  bool typing = false;
  String previousDJ = "None";
  String filter = "";
  DateFormat formatter = DateFormat('jm');

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

  @override
  void initState() {
    super.initState();
    futureSongs = fetchSongs();

    futureSongs.whenComplete(() {
      allLoaded = true;
      setState(() {});
    });

    //sets up the search bar
    _searchTextController.addListener(() {
      filter = _searchTextController.text;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (allLoaded) {
      //Widget used for appBase with the search bar
      Widget appBarSearch = SizedBox(
          width: 500,
          child: TextField(
            style: const TextStyle(color: Colors.black),
            controller: _searchTextController,
            onChanged: onSearchTextChanged,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.black, width: 1)),
              hintText: "Search",
              suffixIcon: IconButton(
                  onPressed: clearText, icon: const Icon(Icons.clear)),
            ),
          ));

      //Widget used for appBase without the search bar
      Widget appBarBase = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ON AIR:',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 9.0,
                    backgroundImage: AssetImage('assets/images/loading.gif'),
                    backgroundColor: Colors.transparent,
                  ),
                  Text(
                    //need input from api
                    "Test DJ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ]),
          ]);

      //creates the break row in the list
      Container _previousDJRow(String dj) {
        return Container(
          height: 50,
          color: const Color.fromARGB(212, 92, 71, 49),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 9.0,
                  backgroundImage: AssetImage('assets/images/loading.gif'),
                  backgroundColor: Colors.transparent,
                ),
                Text(
                  ' ' + dj,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ]),
        );
      }

      //creates the (Spotify, Apple, and Amazon) music links
      InkWell _musicPlayerLink(String logo, String name, String link) {
        return InkWell(
            hoverColor: Colors.white,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(
                logo,
                width: 12,
                height: 12,
              ),
              Text(" " + name,
                  style: const TextStyle(
                    height: 1.1,
                    fontSize: 14,
                  ))
            ]),
            onTap: () => launch(link));
      }

      //creates the row that displays all the info of a song
      ListTile _infoRow(List<SongInfo> songList, int index) {
        String? songID = songList[index].songSpotifyID;
        String songUrl = "";
        if (songID != null) {
          songUrl = "https://open.spotify.com/track/$songID";
        }
        return ListTile(
          //album cover of song
          leading:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(formatter.format(DateTime.fromMillisecondsSinceEpoch(
                songList[index].lastPlayed * 1000))),
          ]),
          title: Text(songList[index].songName),
          subtitle: Text(
              songList[index].artistName + " - " + songList[index].albumName),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _musicPlayerLink(
                    'assets/images/spotify.png', "Spotify", songUrl),
                _musicPlayerLink('assets/images/apple.png', "Itunes",
                    'https://music.apple.com/us/album/never-gonna-give-you-up/1558533900?i=1558534271'),
                _musicPlayerLink('assets/images/amazon.png', "Amazon",
                    'https://www.amazon.com/Never-Gonna-Give-You-Up/dp/B07X66DCLM/ref=sr_1_1?crid=32G0JAXOGTXGR&keywords=never+gonna+give+you+up+rick+astley&qid=1638585041&s=dmusic&sprefix=never+gonn%2Cdigital-music%2C189&sr=1-1')
              ]),
        );
      }

      //builder of song list with dj breaks
      ListView _songList(List<SongInfo> songList) {
        return ListView.builder(
            //the entire scrollable section
            controller: _scrollController,
            itemBuilder: (context, index) {
              return Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: songList[index].songName == ""
                      ? _previousDJRow(songList[index].dj)
                      : _infoRow(songList, index));
            },
            itemCount: songList.length);
      }

      //app layout
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: typing ? appBarSearch : appBarBase,
          backgroundColor: const Color.fromARGB(212, 92, 71, 49),
          actions: [
            IconButton(
                icon: Icon(typing ? Icons.done : Icons.search),
                onPressed: () {
                  setState(() {
                    typing = !typing;
                  });
                }),
          ],
        ),
        body: Center(
            child: FutureBuilder<Songs>(
                future: futureSongs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    songInfoListFuture = snapshot.data!.songs;
                    for (int i = 0; i < songInfoListFuture.length; i++) {
                      SongInfo convertedInfo = SongInfo(
                        songName: songInfoListFuture[i]['title'],
                        artistName: songInfoListFuture[i]['artist'],
                        albumName: songInfoListFuture[i]['album'],
                        dj: "Example DJ",
                        lastPlayed: songInfoListFuture[i]
                            ['last_played_timestamp'],
                        imageUrl: songInfoListFuture[i]['art_url'],
                        artistSpotifyID: songInfoListFuture[i]
                            ['artist_spotify_id'],
                        songSpotifyID: songInfoListFuture[i]['song_spotify_id'],
                      );
                      songInfoList.add(convertedInfo);
                    }
                    return Column(children: [
                      Expanded(
                          child: Stack(children: [
                        searchResults.isNotEmpty ||
                                _searchTextController.text.isNotEmpty
                            ? _songList(searchResults)
                            : _songList(songInfoList),
                      ]))
                    ]);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })),
      );
    }

    // when app is loading initially, a progress indicator will display
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  //logic for search bar
  onSearchTextChanged(String text) async {
    searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (SongInfo songDetail in songInfoList) {
      if (text.length <= songDetail.songName.length ||
          text.length <= songDetail.artistName.length) {
        if (songDetail.songName.toLowerCase().contains(text.toLowerCase()) ||
            songDetail.artistName.toLowerCase().contains(text.toLowerCase()) ||
            songDetail.songName == "") {
          searchResults.add(songDetail);
        }
      }
    }

    for (int i = 0; i < searchResults.length - 1; i++) {
      while (searchResults.length > 1 &&
          searchResults[i].songName == searchResults[i + 1].songName) {
        searchResults.removeAt(i);
        if (i == searchResults.length - 1) {
          break;
        }
      }
    }

    // may need to be added back once dj breaks are re-implemented
    //
    // for (int i = 0; i < searchResults.length - 1; i++) {
    //   while (searchResults.length > 1 &&
    //       searchResults[i].songName == searchResults[i + 1].songName &&
    //       searchResults[i].songName == "") {
    //     searchResults.removeAt(i);
    //     if (i == searchResults.length - 1) {
    //       break;
    //     }
    //   }
    // }
    //
    // if (searchResults[searchResults.length - 1].songName == "") {
    //   searchResults.removeAt(searchResults.length - 1);
    // }

    setState(() {});
  }

  void clearText() {
    _searchTextController.clear();
    onSearchTextChanged("");
  }
}
