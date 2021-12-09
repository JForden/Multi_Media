import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

//SongInfo class may be added to in the future
//I just assumed some values we would be getting from the API
class SongInfo {
  String songName;
  String artistName;
  String albumName;
  String dj;

  SongInfo(
      {required this.songName,
      required this.artistName,
      required this.albumName,
      required this.dj});
}

class _PlaylistPageState extends State<PlaylistPage> {
  final ScrollController _scrollController = ScrollController();
  final _searchTextController = TextEditingController();
  List<SongInfo> songInfoList = [];
  List<SongInfo> searchResults = [];
  bool loading = false;
  bool allLoaded = false;
  bool isHover = false;
  bool typing = false;
  String previousDJ = "None";
  String filter = "";
  DateFormat formatter = DateFormat('jm');
  DateTime time = DateTime.now();

//Gets all the values that would be displayed
//Will be changed once we connect to the API
  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    //simulates a delay when getting data
    await Future.delayed(const Duration(milliseconds: 500));
    //generates 60 items to put in the songList
    //only puts 20 items in initially until the bottom of the screen is reached
    List<SongInfo> initialData = songInfoList.length >= 60
        ? []
        : List.generate(
            20,
            (index) => SongInfo(
                songName: "Interesting Song #${index + songInfoList.length}",
                artistName: "Example Artist",
                albumName: "Example Album Name",
                dj: "Example DJ"));
    if (initialData.isNotEmpty) {
      initialData[10].dj = "That Other DJ";
      initialData[10].songName = "That Other Interesting Song";
      //When a different DJ starts playing, a break will be put in the list with the DJs name and icon
      for (int i = 0; i < initialData.length; i++) {
        if (previousDJ != "None" && previousDJ != initialData[i].dj) {
          songInfoList.add(SongInfo(
              //A SongInfo with null info is used for the break
              songName: "",
              artistName: "",
              albumName: "",
              dj: initialData[i].dj));
        }
        songInfoList.add(initialData[i]);
        previousDJ = initialData[i].dj;
      }
    }
    setState(() {
      loading = false;
      allLoaded = initialData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    //sets up the search bar
    _searchTextController.addListener(() {
      filter = _searchTextController.text;
      setState(() {});
    });
    //checks that the user has reached the end of the list and will fetch more data
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (songInfoList.isNotEmpty) {
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
                children: [
                  const CircleAvatar(
                    radius: 9.0,
                    backgroundImage: AssetImage('assets/images/loading.gif'),
                    backgroundColor: Colors.transparent,
                  ),
                  Text(
                    ' ' + songInfoList[0].dj,
                    style: const TextStyle(
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
        return ListTile(
          //album cover of song
          leading: Text(formatter.format(time)),
          title: Text(songList[index].songName),
          subtitle: Text(
              songList[index].artistName + " - " + songList[index].albumName),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _musicPlayerLink('assets/images/spotify.png', "Spotify",
                    'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd'),
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
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(children: [
            Expanded(
                child: Stack(children: [
              searchResults.isNotEmpty || _searchTextController.text.isNotEmpty
                  ? _songList(searchResults)
                  : _songList(songInfoList),
              if (loading) ...[
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: 80,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ))
              ]
            ]))
          ]);
        }),
      );
    }
    //when app is loading initially, a progress indicator will display
    else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  //logic for search bar
  onSearchTextChanged(String text) async {
    searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (SongInfo songDetail in songInfoList) {
      if (songDetail.songName.toLowerCase().contains(text.toLowerCase()) ||
          songDetail.artistName.toLowerCase().contains(text.toLowerCase()) ||
          songDetail.songName == "") {
        searchResults.add(songDetail);
      }
    }

    for (int i = 0; i < searchResults.length - 1; i++) {
      while (searchResults.length > 1 &&
          searchResults[i].songName == searchResults[i + 1].songName &&
          searchResults[i].songName == "") {
        searchResults.removeAt(i);
        if (i == searchResults.length - 1) {
          break;
        }
      }
    }

    if (searchResults[searchResults.length - 1].songName == "") {
      searchResults.removeAt(searchResults.length - 1);
    }

    setState(() {});
  }

  void clearText() {
    _searchTextController.clear();
    onSearchTextChanged("");
  }
}
