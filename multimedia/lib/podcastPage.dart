import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "main.dart";
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:url_launcher/url_launcher.dart';

class PodcastData {
  final String title;
  final String url_link;
  final String image_URL;

  PodcastData(this.title, this.url_link, this.image_URL);
}

class ExtractPodcastData extends StatefulWidget {
  @override
  _ExtractPodcastDataState createState() => _ExtractPodcastDataState();
  const ExtractPodcastData({Key? key}) : super(key: key);
  static const routeName = '/PodcastArguments';
}

class _ExtractPodcastDataState extends State<ExtractPodcastData> {
  IconData playIcon = Icons.play_arrow;
  bool playing = false;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = args['title'];
    final url_link = args['url_link'];
    final image_URL = args['image_url'];
    final PodcastData podcastData = PodcastData(
        title.toString(), url_link.toString(), image_URL.toString());
    print(title);
    print(image_URL);
    print(url_link);
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    Widget titleSection(podcastData) {
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
                        podcastData.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "88Nine Podcasts", //current title and podcast name
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

    Widget playButtonSection = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlayButton(Theme.of(context).primaryColor, playIcon, "Play"),
      ],
    );

    //create Ui for playing podcast here.
    return MaterialApp(
        title: 'Podcast Page',
        home: Scaffold(
            body: Center(
                child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: deviceHeight * 0.05),
                child: FadeInImage.assetNetwork(
                  image: podcastData.image_URL,
                  placeholder: 'assets/images/loading.gif',
                  imageErrorBuilder: (context, error, stackTrace) {
                    //if the image fails to load, it will display a placeholder image.
                    return Image.asset('assets/images/loading.gif');
                  },
                  width: 200,
                  height: 200,
                )),
            titleSection(podcastData),
            playButtonSection,
          ],
        ))));
  }

  InkWell _buildPlayButton(Color color, IconData icon, String text) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    FlutterRadioPlayer newRadio = FlutterRadioPlayer(); //just audio player
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
            decoration: BoxDecoration(
                color: Theme.of(context).splashColor, shape: BoxShape.circle),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(playIcon,
                    color: Theme.of(context).backgroundColor,
                    size: deviceHeight * 0.08),
              ],
            )));
  }
}
