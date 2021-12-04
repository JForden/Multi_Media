import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false;
  bool allLoaded = false;

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => "Example Song #${index + items.length}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
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
    DateTime time = DateTime.now();
    final DateFormat timeFormatter = DateFormat('jm');
    final DateFormat monthFormatter = DateFormat('LLLL');
    final DateFormat dayFormatter = DateFormat('d');
    final String formattedTime = timeFormatter.format(time);
    final String formattedDate =
        monthFormatter.format(time) + ' ' + dayFormatter.format(time);

    return Scaffold(
      // appBar: AppBar(
      //     centerTitle: true,
      //     title: const Text("Example DJ" " ON AIR"),
      //     backgroundColor: Colors.brown),
      body: LayoutBuilder(builder: (context, constraints) {
        if (items.isNotEmpty) {
          return Column(children: [
            Container(
              height: 50,
              color: Colors.brown,
              width: constraints.maxWidth,
              child: Row(children: [
                Text(formattedDate),
                const Text(
                  'DJ ON AIR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  child: const Text('Search'),
                  onTap: () =>
                      launch('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
                ),
              ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            ),
            Expanded(
                child: Stack(children: [
              ListView.builder(
                  //the entire scrollable section
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: ListTile(
                            //where each row is made
                            leading: Image.asset(
                              'assets/images/loading.gif',
                            ),
                            title: Text(items[index]),
                            subtitle: const Text(
                                "Example Artist" " - " "Example Album"),
                            trailing: Column(
                              children: [
                                InkWell(
                                    child: const Text("Spotify",
                                        style: TextStyle(
                                            height: 1.1, fontSize: 14)),
                                    onTap: () => launch(
                                        'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd')),
                                InkWell(
                                    child: const Text("Itunes",
                                        style: TextStyle(
                                            height: 1.1, fontSize: 14)),
                                    onTap: () => launch(
                                        'https://music.apple.com/us/album/never-gonna-give-you-up/1558533900?i=1558534271')),
                                InkWell(
                                    child: const Text("Amazon",
                                        style: TextStyle(
                                            height: 1.1, fontSize: 14)),
                                    onTap: () => launch(
                                        'https://www.amazon.com/Never-Gonna-Give-You-Up/dp/B07X66DCLM/ref=sr_1_1?crid=32G0JAXOGTXGR&keywords=never+gonna+give+you+up+rick+astley&qid=1638585041&s=dmusic&sprefix=never+gonn%2Cdigital-music%2C189&sr=1-1')),
                              ],
                            )));
                  },
                  itemCount: items.length),
              if (loading) ...[
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: constraints.maxWidth,
                      height: 80,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ))
              ]
            ]))
          ]);
        } else {
          return Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }
}
