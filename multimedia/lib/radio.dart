import 'package:flutter/material.dart';
import 'package:multimedia/songs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  IconData playIcon = Icons.play_arrow;
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    Widget titleSection(SongInfo currentSong) {
      return Container(
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
                      //padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        currentSong.songName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      currentSong.artistName + " - " + currentSong.albumName,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    }

    Color color = Theme.of(context).primaryColor;

    Widget playButtonSection = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayButton(color, playIcon, "Play"),
      ],
    );

    Widget buttonSection(SongInfo currentSong) {
      String artistUrl = "";
      if (currentSong.artistSpotifyID != null) {
        artistUrl =
            'https://open.spotify.com/artist/' + currentSong.artistSpotifyID;
      }
      String songUrl = "";
      if (currentSong.songSpotifyID != null) {
        songUrl = 'https://open.spotify.com/track/' + currentSong.songSpotifyID;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
            color,
            Icons.person_sharp,
            'Artist info',
            artistUrl,
          ),
          _buildButtonColumn(color, Icons.list, 'Add to playlist', songUrl),
          _buildButtonColumn(color, Icons.share, 'Share',
              'https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT?si=6eb186f21dd749bd'),
        ],
      );
    }

    Widget textSection(SongInfo currentSong) {
      return Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Info about current stream',
          softWrap: true,
        ),
      );
    }

    return MaterialApp(
        title: 'Radio Page',
        home: Scaffold(
            body: Center(
                child: FutureBuilder<Songs>(
                    future: fetchSongs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> songInfoListFuture = snapshot.data!.songs;
                        SongInfo currentSong = SongInfo(
                            songName: songInfoListFuture[0]['title'],
                            artistName: songInfoListFuture[0]['artist'],
                            albumName: songInfoListFuture[0]['album'],
                            dj: "Example DJ",
                            lastPlayed: songInfoListFuture[0]
                                ['last_played_timestamp'],
                            imageUrl: songInfoListFuture[0]['art_url'],
                            artistSpotifyID: songInfoListFuture[0]
                                ['artist_spotify_id'],
                            songSpotifyID: songInfoListFuture[0]
                                ['song_spotify_id']);

                        return ListView(
                          children: [
                            FadeInImage.assetNetwork(
                              image: currentSong.imageUrl,
                              placeholder: 'assets/images/loading.gif',
                              imageErrorBuilder: (context, error, stackTrace) {
                                //if the image fails to load, it will display a placeholder image.
                                return Image.asset(currentSong.imageUrl);
                              },
                              width: 200,
                              height: 200,
                            ),
                            titleSection(currentSong),
                            playButtonSection,
                            buttonSection(currentSong),
                            textSection(currentSong),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }))),
        debugShowCheckedModeBanner: false);
  }

  InkWell _buildButtonColumn(
      Color color, IconData icon, String label, String link) {
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
        onTap: () => launch(link));
  }

  InkWell _buildPlayButton(Color color, IconData icon, String text) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    FlutterRadioPlayer newRadio = FlutterRadioPlayer();
    newRadio.init("Radio", "Live",
        "https://wyms.streamguys1.com/live?platform=88nine", "false");
    if (playing) {
      newRadio.play();
    } else {
      newRadio.pause();
    }

    return InkWell(
        onTap: () {
          if (playing) {
            playIcon = Icons.play_arrow;
            playing = false;
          } else {
            playIcon = Icons.pause;
            playing = true;
          }
          setState(() {});
        },
        child: Container(
            width: deviceWidth * 0.2,
            height: deviceHeight * 0.2,
            decoration:
                BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(playIcon, color: Colors.white, size: deviceHeight * 0.08),
              ],
            )));
  }
}
