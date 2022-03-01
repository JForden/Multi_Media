import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class CurrentSongInfo {
  String currentSongName = "";
  String currentArtistName = "";
  String currentSongAlbum = "";
  String currentDJ = "";

  CurrentSongInfo(String currentSongName, String currentArtistName, String currentSongAlbum, String currentDJ)
    {
      this.currentSongName = currentSongName;
      this.currentArtistName = currentArtistName;
      this.currentSongAlbum = currentSongAlbum;
      this.currentDJ = currentDJ;
    }
}

class _RadioPageState extends State<RadioPage> {

var songInfo = CurrentSongInfo(
  "Bohemian Rhapsody",
  "Queen",
  "A Night At The Opera",
  "Me"
);

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    songInfo.currentSongName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  songInfo.currentArtistName + " - " + songInfo.currentSongAlbum,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.person_sharp, 'Artist info', 'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd'),
        _buildButtonColumn(color, Icons.list, 'Add to playlist', 'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd'),
        _buildButtonColumn(color, Icons.share, 'Share', 'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd'),
      ],
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Info about current stream',
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: 'Radio Page',
      home: Scaffold(
        body: ListView(
          children: [
            Image.asset(
              'assets/images/loading.gif',
              width: 200,
              height: 200,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    debugShowCheckedModeBanner: false
    );
  }

  InkWell _buildButtonColumn(Color color, IconData icon, String label, String link) {
    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
      onTap: () => launch(link)
    );
  }
}