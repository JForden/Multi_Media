// ignore_for_file: deprecated_member_use
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'wp_api.dart';
//import 'package:html/parser.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: ListView(
            children: [
              Image.asset(
                "assets/images/logo.jpg",
                width: 250,
                height: 250,
              ),
              mainSection
            ],
          ),
        ),
        debugShowCheckedModeBanner: false);
  }
}
// _launchURLApp() async {
//     const url = 'https://flutterdevs.com/';
//     if (await canLaunch(url)) {
//       await launch(url, forceSafariVC: true, forceWebView: true);
//     } else {
//       throw 'Could not launch $url';
//     }

Widget mainSection = Column(
  children: [
    FutureBuilder(
        future: fetchWpPosts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Map wppost = snapshot.data[index];
                var imageurl =
                    wppost["_embedded"]["wp:featuredmedia"][0]["source_url"];
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text(
                      wppost['title']['rendered']
                          .replaceAll('&#8216;', '\'')
                          .replaceAll('&#8217;', '\'')
                          .replaceAll('&#8212;', '-')
                          .replaceAll('&#038;', '&'),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    Image.network(imageurl),
                  ]),
                );
                return ListTile(
                  onTap: () {
                    //when the user taps on an article, it will open a new page with the article's content.
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed('/Article', arguments: {
                      'title': wppost['title']['rendered']
                          .replaceAll('&#8216;', '\'')
                          .replaceAll('&#8217;', '\'')
                          .replaceAll('&#8212;', '-')
                          .replaceAll('&#038;', '&')
                          .toString(),
                      'content': snapshot.data[index]['content']['rendered']
                          .toString(),
                    });
                  },
                  //returns a list tile with the title formmatted.

                  title: Text(
                    '\n' +
                        wppost['title']['rendered']
                            .replaceAll('&#8216;', '\'')
                            .replaceAll('&#8217;', '\'')
                            .replaceAll('&#8212;', '-')
                            .replaceAll('&#038;', '&'),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: FadeInImage.assetNetwork(
                    image: imageurl,
                    placeholder: 'assets/images/loading.gif',
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        }),
    FlatButton(
        child: Text(
          'View all...',
          style: const TextStyle(
              fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black),
        ),
        onPressed: () => launch('https://radiomilwaukee.org/')),
    FutureBuilder(
        future: fetchWpPosts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Map wppost = snapshot.data[index];
                var imageurl =
                    wppost["_embedded"]["wp:featuredmedia"][0]["source_url"];
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text(
                      wppost['title']['rendered']
                          .replaceAll('&#8216;', '\'')
                          .replaceAll('&#8217;', '\'')
                          .replaceAll('&#8212;', '-')
                          .replaceAll('&#038;', '&'),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    Image.network(imageurl),
                  ]),
                );
                return ListTile(
                  onTap: () {
                    //when the user taps on an article, it will open a new page with the article's content.
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed('/Article', arguments: {
                      'title': wppost['title']['rendered']
                          .replaceAll('&#8216;', '\'')
                          .replaceAll('&#8217;', '\'')
                          .replaceAll('&#8212;', '-')
                          .replaceAll('&#038;', '&')
                          .toString(),
                      'content': snapshot.data[index]['content']['rendered']
                          .toString(),
                    });
                  },
                  //returns a list tile with the title formmatted.

                  title: Text(
                    '\n' +
                        wppost['title']['rendered']
                            .replaceAll('&#8216;', '\'')
                            .replaceAll('&#8217;', '\'')
                            .replaceAll('&#8212;', '-')
                            .replaceAll('&#038;', '&'),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: FadeInImage.assetNetwork(
                    image: imageurl,
                    placeholder: 'assets/images/loading.gif',
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        }),
    FlatButton(
        child: Text(
          'View all...',
          style: const TextStyle(
              fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black),
        ),
        onPressed: () => launch('https://radiomilwaukee.org/')),
  ],
);

class newPage {
  final String title;
  final String description;

  newPage(this.title, this.description);
}

class newPageData extends StatelessWidget {
  const newPageData({Key? key}) : super(key: key);
  //static const routeName = '/Article';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = args['title'];
    final content = args['content'];
    //loop through content and print out the html tags.
    //print(title);
    //print(content);
    String content1 = "";
    if (content != null) {
      content1 = content
          .replaceAll('SUPPORTER', '')
          .replaceAll('<div class="ad-left">', "")
          .replaceAll(
              "<div class=\"wp-block-custom-ads google-ads-two-up\">", "")
          .replaceAll(
              "<iframe class=\"dfpAdLoader\" scrolling=\"no\" seamless=\"seamless\" src=\"/dfp-basic-ad-loader.php?slot=/118058336/Story-BB-Left&amp;width=300&amp;height=250\">",
              "")
          .replaceAll("<div class\"ad-right\">", "replace2")
          .replaceAll(
              "<iframe class=\"dfpAdLoader\" scrolling=\"no\" seamless=\"seamless\" src=\"/dfp-basic-ad-loader.php?slot=/118058336/Story-BB-Right&amp;width=300&amp;height=250\">",
              "")
          .replaceAll("<div class=\"google-ad\">", "");
    }
    //print("here");
    //print(content1);
    //print(content1.toString());
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                title.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //add a thin bar between the title and the content.
              Divider(
                color: Theme.of(context).dividerColor,
                thickness: 3.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              Html(
                data: content1,
                style: {
                  'html': Style(textAlign: TextAlign.center),
                  //'h1': Style(color: Colors.red),
                  //'p': Style(color: Colors.black87, fontSize: FontSize.medium),
                  //'body': Style(alignment: Alignment.center),
                  //'ul': Style(margin: const EdgeInsets.symmetric(vertical: 20))
                },
              ),
            ],
          ),
        )));
  }
}
