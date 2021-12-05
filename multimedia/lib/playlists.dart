import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

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

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
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
      for (int i = 0; i < initialData.length; i++) {
        if (previousDJ != "None" && previousDJ != initialData[i].dj) {
          songInfoList.add(SongInfo(
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
    _searchTextController.addListener(() {
      filter = _searchTextController.text;
      setState(() {});
    });
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
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: typing
              ? SizedBox(
                  width: 500,
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _searchTextController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      hintText: "Search",
                      suffixIcon: IconButton(
                          onPressed: clearText, icon: const Icon(Icons.clear)),
                    ),
                    onChanged: onSearchTextChanged,
                  ))
              : Column(
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
                              backgroundImage:
                                  AssetImage('assets/images/loading.gif'),
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
                    ]),
          backgroundColor: const Color.fromARGB(212, 92, 71, 49),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    typing = !typing;
                  });
                },
                icon: Icon(typing ? Icons.done : Icons.search))
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(children: [
            Expanded(
                child: Stack(children: [
              searchResults.isNotEmpty || _searchTextController.text.isNotEmpty
                  ? ListView.builder(
                      //the entire scrollable section
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: searchResults[index].songName == ""
                                ? Container(
                                    height: 50,
                                    color:
                                        const Color.fromARGB(212, 92, 71, 49),
                                    width: constraints.maxWidth,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 9.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/loading.gif'),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          Text(
                                            ' ' + searchResults[index].dj,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ]),
                                  )
                                : ListTile(
                                    //where each row is made
                                    leading: Image.asset(
                                      'assets/images/loading.gif',
                                    ),
                                    title: Text(searchResults[index].songName),
                                    subtitle: Text(
                                        searchResults[index].artistName +
                                            " - " +
                                            searchResults[index].albumName),
                                    trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              hoverColor: Colors.white,
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    CircleAvatar(
                                                      radius: 7.0,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/spotify.png'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                    Text(" Spotify",
                                                        style: TextStyle(
                                                          height: 1.1,
                                                          fontSize: 14,
                                                        ))
                                                  ]),
                                              onTap: () => launch(
                                                  'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd')),
                                          InkWell(
                                              hoverColor: Colors.white,
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/apple.png',
                                                      width: 14,
                                                      height: 14,
                                                    ),
                                                    const Text(" Itunes",
                                                        style: TextStyle(
                                                            height: 1.1,
                                                            fontSize: 14)),
                                                  ]),
                                              onTap: () => launch(
                                                  'https://music.apple.com/us/album/never-gonna-give-you-up/1558533900?i=1558534271')),
                                          InkWell(
                                              hoverColor: Colors.white,
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    CircleAvatar(
                                                      radius: 8.0,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/amazon.jpg'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                    Text(" Amazon",
                                                        style: TextStyle(
                                                            height: 1.1,
                                                            fontSize: 14)),
                                                  ]),
                                              onTap: () => launch(
                                                  'https://www.amazon.com/Never-Gonna-Give-You-Up/dp/B07X66DCLM/ref=sr_1_1?crid=32G0JAXOGTXGR&keywords=never+gonna+give+you+up+rick+astley&qid=1638585041&s=dmusic&sprefix=never+gonn%2Cdigital-music%2C189&sr=1-1')),
                                        ]),
                                  ));
                      },
                      itemCount: searchResults.length)
                  : ListView.builder(
                      //the entire scrollable section
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: songInfoList[index].songName == ""
                                ? Container(
                                    height: 50,
                                    color:
                                        const Color.fromARGB(212, 92, 71, 49),
                                    width: constraints.maxWidth,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 9.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/loading.gif'),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          Text(
                                            ' ' + songInfoList[index].dj,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ]),
                                  )
                                : ListTile(
                                    //where each row is made
                                    leading: Image.asset(
                                      'assets/images/loading.gif',
                                    ),
                                    title: Text(songInfoList[index].songName),
                                    subtitle: Text(
                                        songInfoList[index].artistName +
                                            " - " +
                                            songInfoList[index].albumName),
                                    trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              hoverColor: Colors.white,
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    CircleAvatar(
                                                      radius: 7.0,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/spotify.png'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                    Text(" Spotify",
                                                        style: TextStyle(
                                                          height: 1.1,
                                                          fontSize: 14,
                                                        ))
                                                  ]),
                                              onTap: () => launch(
                                                  'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd')),
                                          InkWell(
                                              hoverColor: Colors.white,
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/apple.png',
                                                      width: 14,
                                                      height: 14,
                                                    ),
                                                    const Text(" Itunes",
                                                        style: TextStyle(
                                                            height: 1.1,
                                                            fontSize: 14)),
                                                  ]),
                                              onTap: () => launch(
                                                  'https://music.apple.com/us/album/never-gonna-give-you-up/1558533900?i=1558534271')),
                                          InkWell(
                                              hoverColor: Colors.white,
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    CircleAvatar(
                                                      radius: 8.0,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/amazon.jpg'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                    Text(" Amazon",
                                                        style: TextStyle(
                                                            height: 1.1,
                                                            fontSize: 14)),
                                                  ]),
                                              onTap: () => launch(
                                                  'https://www.amazon.com/Never-Gonna-Give-You-Up/dp/B07X66DCLM/ref=sr_1_1?crid=32G0JAXOGTXGR&keywords=never+gonna+give+you+up+rick+astley&qid=1638585041&s=dmusic&sprefix=never+gonn%2Cdigital-music%2C189&sr=1-1')),
                                        ]),
                                  ));
                      },
                      itemCount: songInfoList.length),
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
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

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
