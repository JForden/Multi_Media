import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class DJInfo {
  String djName;
  TimeOfDay time;
  String day;

  DJInfo({required this.djName, required this.time, required this.day});
}

class SongInfo {
  String songName;
  String artistName;
  String albumName;
  String dj = "Example DJ";
  int lastPlayed;
  String spotifyID = "";

  SongInfo({
    required this.songName,
    required this.artistName,
    required this.albumName,
    required this.dj,
    required this.lastPlayed,
    required this.spotifyID,
  });
}

class ItunesInfo {
  List<dynamic> results;

  ItunesInfo({required this.results});

  factory ItunesInfo.fromJson(Map<String, dynamic> json) {
    return ItunesInfo(results: json['results']);
  }
}

class Songs {
  List<dynamic> songs;

  Songs({required this.songs});

  factory Songs.fromJson(Map<String, dynamic> json) {
    return Songs(songs: json['songs']);
  }
}

class _PlaylistPageState extends State<PlaylistPage> {
  final ScrollController _scrollController = ScrollController();
  final _searchTextController = TextEditingController();
  List<SongInfo> songInfoList = [];
  List<SongInfo> searchResults = [];
  List<SongInfo> allRows = [];
  late Future<Songs> futureSongs;
  late Future<ItunesInfo> futureItunesInfo;
  List<dynamic> songInfoListFuture = [];
  List<dynamic> itunesSongInfoFuture = [];
  List<DJInfo> djInfoList = [];
  bool allLoaded = false;
  bool isHover = false;
  bool typing = false;
  String previousDJ = "None";
  String filter = "";
  String itunesUrl = "";
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

//https://itunes.apple.com/search?term=What%2C%20Me%20Worry%3F&entity=song
  Future<ItunesInfo> fetchItunesSongId(
      String songName, String artistName, String albumName) async {
    //print('https://itunes.apple.com/search?term=' + Uri.encodeComponent(songName + ' ' + artistName + ' ' + albumName) + '&entity=song');

    final response = await http.get(Uri.parse(
        'https://itunes.apple.com/search?term=' +
            Uri.encodeFull(songName + ' ' + artistName + ' ' + albumName) +
            '&entity=song'));

    //print(response.body.isEmpty);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ItunesInfo.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Itunes query');
    }
  }

  fillDJInfoList() {
    //DJ times for Monday-Wednesday
    String day = "Monday";
    for (int i = 0; i < 3; i++) {
      djInfoList.add(DJInfo(
          day: day,
          djName: "Overnight",
          time: const TimeOfDay(hour: 0, minute: 0)));
      djInfoList.add(DJInfo(
          day: day,
          djName: "Dori Zori",
          time: const TimeOfDay(hour: 6, minute: 0)));
      djInfoList.add(DJInfo(
          day: day,
          djName: "Marcus Doucette",
          time: const TimeOfDay(hour: 10, minute: 0)));
      djInfoList.add(DJInfo(
          day: day,
          djName: "Justin Barney",
          time: const TimeOfDay(hour: 14, minute: 0)));
      djInfoList.add(DJInfo(
          day: day,
          djName: "Nate Imig",
          time: const TimeOfDay(hour: 18, minute: 0)));
      djInfoList.add(DJInfo(
          day: day,
          djName: "88Nine After 9 w/ Tarik Moody",
          time: const TimeOfDay(hour: 21, minute: 0)));

      if (day == "Monday") {
        day = "Tuesday";
      } else if (day == "Tuesday") {
        day = "Wednesday";
      }
    }

    //DJ times for Thursday
    djInfoList.add(DJInfo(
        day: day,
        djName: "Overnight",
        time: const TimeOfDay(hour: 0, minute: 0)));
    djInfoList.add(DJInfo(
        day: day,
        djName: "Dori Zori",
        time: const TimeOfDay(hour: 6, minute: 0)));
    djInfoList.add(DJInfo(
        day: day,
        djName: "Marcus Doucette",
        time: const TimeOfDay(hour: 10, minute: 0)));
    djInfoList.add(DJInfo(
        day: day,
        djName: "Justin Barney",
        time: const TimeOfDay(hour: 14, minute: 0)));
    djInfoList.add(DJInfo(
        day: day,
        djName: "414 Live (Thursdays)",
        time: const TimeOfDay(hour: 17, minute: 30)));
    djInfoList.add(DJInfo(
        day: day,
        djName: "Nate Imig",
        time: const TimeOfDay(hour: 18, minute: 0)));
    djInfoList.add(DJInfo(
        day: day,
        djName: "88Nine After 9 w/ Tarik Moody",
        time: const TimeOfDay(hour: 21, minute: 0)));

    //DJ times for Friday
    djInfoList.add(DJInfo(
        day: "Friday",
        djName: "Overnight",
        time: const TimeOfDay(hour: 0, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Friday",
        djName: "Dori Zori",
        time: const TimeOfDay(hour: 6, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Friday",
        djName: "Marcus Doucette",
        time: const TimeOfDay(hour: 10, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Friday",
        djName: "Justin Barney",
        time: const TimeOfDay(hour: 14, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Friday",
        djName: "Nate Imig",
        time: const TimeOfDay(hour: 18, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Friday",
        djName: "Tarik Moody",
        time: const TimeOfDay(hour: 21, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Friday",
        djName: "Rhythm Lab Radio",
        time: const TimeOfDay(hour: 22, minute: 0)));

    //DJ times for Saturday
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "Overnight",
        time: const TimeOfDay(hour: 0, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "Anthony Foster",
        time: const TimeOfDay(hour: 6, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "Kids Disco with Dori Zori",
        time: const TimeOfDay(hour: 9, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "Let's Hear It with Marcus Doucette",
        time: const TimeOfDay(hour: 10, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "Element Everest-Blanks",
        time: const TimeOfDay(hour: 12, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "Kat Froelich",
        time: const TimeOfDay(hour: 15, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "Kenny Perez",
        time: const TimeOfDay(hour: 18, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Saturday",
        djName: "In The Mix with DJ Kenny Perez",
        time: const TimeOfDay(hour: 22, minute: 0)));

    //DJ times for Sunday
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Overnight",
        time: const TimeOfDay(hour: 0, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Doris Wessels",
        time: const TimeOfDay(hour: 6, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Chris Alexander",
        time: const TimeOfDay(hour: 9, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Element Everest-Blanks",
        time: const TimeOfDay(hour: 12, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Kat Froelich",
        time: const TimeOfDay(hour: 15, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Sound Travels with Marcus Doucette",
        time: const TimeOfDay(hour: 18, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "SHEROES with Carmel Holt",
        time: const TimeOfDay(hour: 19, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "From the Music Desk with Justin Barney",
        time: const TimeOfDay(hour: 20, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Sound Opinions",
        time: const TimeOfDay(hour: 21, minute: 0)));
    djInfoList.add(DJInfo(
        day: "Sunday",
        djName: "Rhythm Lab Radio",
        time: const TimeOfDay(hour: 22, minute: 0)));
  }

  @override
  void initState() {
    super.initState();
    futureSongs = fetchSongs();
    fillDJInfoList();

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
            style: TextStyle(
                color: Theme.of(context).dividerColor, fontFamily: "Helvetica"),
            controller: _searchTextController,
            onChanged: onSearchTextChanged,
            decoration: InputDecoration(
              fillColor: Theme.of(context).backgroundColor,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1)),
              hintText: "Search",
              suffixIcon: IconButton(
                  onPressed: clearText, icon: const Icon(Icons.clear)),
            ),
          ));

      //Widget used for appBase without the search bar
      Widget appBarBase = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 11.0,
                  backgroundImage: AssetImage('assets/images/loading.gif'),
                  backgroundColor: Colors.transparent,
                )),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ON AIR:',
                    style: Theme.of(context).primaryTextTheme.headlineSmall,
                  ),
                  Text(
                    //need input from api
                    "Test DJ",
                    style: Theme.of(context).primaryTextTheme.headlineSmall,
                  ),
                ])
          ]);

      //creates the break row in the list
      Container _previousDJRow(String dj) {
        return Container(
          height: 50,
          color: Theme.of(context).primaryColorLight,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      radius: 11.0,
                      backgroundImage: AssetImage('assets/images/loading.gif'),
                      backgroundColor: Colors.transparent,
                    )),
                Text(
                  ' ' + dj,
                  style: Theme.of(context).primaryTextTheme.headlineSmall,
                ),
              ]),
        );
      }

      //creates the (Spotify, Apple, and Amazon) music links
      InkWell _musicPlayerLink(
          String logo, String name, String link, bool flag) {
        if (flag) {
          return InkWell(
              hoverColor: Theme.of(context).backgroundColor,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(
                  logo,
                  width: 12,
                  height: 12,
                ),
                Text(" " + name, style: Theme.of(context).textTheme.bodyMedium)
              ]),
              onTap: () => launch(link));
        } else {
          return InkWell(
              hoverColor: Theme.of(context).backgroundColor,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(
                  logo,
                  width: 12,
                  height: 12,
                ),
                Text(" " + name, style: Theme.of(context).textTheme.bodyMedium)
              ]));
        }
      }

      //creates the row that displays all the info of a song
      ListTile _infoRow(List<SongInfo> songList, int index) {
        futureItunesInfo = fetchItunesSongId(songList[index].songName,
            songList[index].artistName, songList[index].albumName);
        //futureItunesInfo.whenComplete(() {setState(() {});});
        return ListTile(
          leading:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(formatter.format(DateTime.fromMillisecondsSinceEpoch(
                songList[index].lastPlayed * 1000))),
          ]),
          title: Text(songList[index].songName,
              style: Theme.of(context).textTheme.titleSmall),
          subtitle: Text(
              songList[index].artistName + " - " + songList[index].albumName),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _musicPlayerLink(
                    'assets/images/spotify.png',
                    "Spotify",
                    'https://open.spotify.com/track/' +
                        songList[index].spotifyID,
                    true),
                FutureBuilder<ItunesInfo>(
                    future: futureItunesInfo,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        itunesSongInfoFuture = snapshot.data!.results;
                        if (itunesSongInfoFuture.isNotEmpty) {
                          for (int i = 0;
                              i < itunesSongInfoFuture.length;
                              i++) {
                            if (itunesSongInfoFuture[i]["artistName"]
                                    .toString()
                                    .contains(songList[index].artistName) &&
                                itunesSongInfoFuture[i]["collectionName"]
                                    .toString()
                                    .contains(songList[index].albumName) &&
                                itunesSongInfoFuture[i]["trackName"]
                                    .toString()
                                    .contains(songList[index].songName)) {
                              itunesUrl =
                                  itunesSongInfoFuture[i]["trackViewUrl"];
                              return _musicPlayerLink('assets/images/apple.png',
                                  "Itunes", itunesUrl, true);
                            }
                          }
                        }
                      }
                      return _musicPlayerLink('assets/images/apple.png',
                          "Itunes", itunesUrl, false);
                    }),
                _musicPlayerLink(
                    'assets/images/amazon.png',
                    "Amazon",
                    'https://www.amazon.com/s?k=' +
                        Uri.encodeFull(songList[index].songName +
                            ' ' +
                            songList[index].artistName) +
                        '&i=digital-music&link_code=qs&tag=88ninradio-20',
                    true)
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
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor)),
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
          backgroundColor: Theme.of(context).primaryColor,
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
                      SongInfo convertedInfo;
                      if (songInfoListFuture[i]['song_spotify_id'] == null) {
                        convertedInfo = SongInfo(
                            songName: songInfoListFuture[i]['title'],
                            artistName: songInfoListFuture[i]['artist'],
                            albumName: songInfoListFuture[i]['album'],
                            dj: "Example DJ",
                            lastPlayed: songInfoListFuture[i]
                                ['last_played_timestamp'],
                            spotifyID: "");
                      } else {
                        convertedInfo = SongInfo(
                            songName: songInfoListFuture[i]['title'],
                            artistName: songInfoListFuture[i]['artist'],
                            albumName: songInfoListFuture[i]['album'],
                            dj: "Example DJ",
                            lastPlayed: songInfoListFuture[i]
                                ['last_played_timestamp'],
                            spotifyID: songInfoListFuture[i]
                                ['song_spotify_id']);
                      }
                      songInfoList.add(convertedInfo);
                    }

                    int mostRecent = TimeOfDay.fromDateTime(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        songInfoList[0].lastPlayed * 1000))
                                .hour *
                            60 +
                        TimeOfDay.fromDateTime(
                                DateTime.fromMillisecondsSinceEpoch(
                                    songInfoList[0].lastPlayed * 1000))
                            .minute;

                    //finds the initial index of most recent played dj
                    int djInfoListIndex = 0;
                    for (int i = 0; i < djInfoList.length; i++) {
                      if (mostRecent -
                                  (djInfoList[i].time.hour * 60 +
                                      djInfoList[i].time.minute) <=
                              mostRecent -
                                  (djInfoList[djInfoListIndex].time.hour * 60 +
                                      djInfoList[djInfoListIndex]
                                          .time
                                          .minute) &&
                          mostRecent -
                                  (djInfoList[i].time.hour * 60 +
                                      djInfoList[i].time.minute) >
                              0 &&
                          djInfoList[i].day ==
                              DateFormat('EEEE').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      songInfoList[0].lastPlayed * 1000))) {
                        djInfoListIndex = i;
                      }
                    }

                    //Puts the DJs and songs into one big list that will be displayed
                    for (int i = 0; i < songInfoList.length; i++) {
                      if ((mostRecent -
                              djInfoList[djInfoListIndex].time.hour * 60 +
                              djInfoList[djInfoListIndex].time.minute) >
                          mostRecent -
                              (TimeOfDay.fromDateTime(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  songInfoList[i].lastPlayed *
                                                      1000))
                                          .hour *
                                      60 +
                                  TimeOfDay.fromDateTime(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              songInfoList[i].lastPlayed *
                                                  1000))
                                      .minute)) {
                        allRows.add(songInfoList[i]);
                        mostRecent = TimeOfDay.fromDateTime(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            allRows[allRows.length - 1]
                                                    .lastPlayed *
                                                1000))
                                    .hour *
                                60 +
                            TimeOfDay.fromDateTime(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        allRows[allRows.length - 1].lastPlayed *
                                            1000))
                                .minute;
                      } else {
                        allRows.add(SongInfo(
                            songName: "",
                            artistName: "",
                            albumName: "",
                            dj: djInfoList[djInfoListIndex].djName,
                            lastPlayed: 0,
                            spotifyID: ""));
                        mostRecent =
                            djInfoList[djInfoListIndex].time.hour * 60 +
                                djInfoList[djInfoListIndex].time.minute;
                        if (djInfoListIndex == 0) {
                          djInfoListIndex = djInfoList.length - 1;
                        } else {
                          djInfoListIndex--;
                        }
                        i--;
                      }
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
