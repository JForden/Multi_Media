import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'wp_api.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News",
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.titleLarge),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot snapshot) {
            //calls the getData function from the WpApi class and returns a list of articles.
            if (snapshot.hasData) {
              //if the list has data, it will return a listview of articles.
              var itemCount = snapshot.data.length;
              String image_URL = "assets/images/apple.png";
              return ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Since the titles use a version of html, we need to parse it and replace some html tags with their respective strings in order to display the title correctly.
                    String art_data =
                        snapshot.data[index]['content']['rendered'];

                    if (snapshot.data[index]['_embedded']['wp:featuredmedia'] !=
                        null) {
                      image_URL = snapshot.data[index]['_embedded']
                          ['wp:featuredmedia'][0]['source_url'];
                    }

                    String title1 = snapshot.data[index]['title']['rendered']
                        .replaceAll('&#8216;', '\'')
                        .replaceAll('&#8217;', '\'')
                        .replaceAll('&#8212;', '-')
                        .replaceAll('&#038;', '&')
                        .replaceAll('&#8220;', '“')
                        .replaceAll('&#8221;', '”');
                    return Card(
                        elevation: 2,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              onTap: () {
                                //when the user taps on an article, it will open a new page with the article's content.
                                Navigator.pushNamed(
                                    context, ExtractArticleData.routeName,
                                    arguments: {
                                      'title': title1.toString(),
                                      'content': art_data.toString(),
                                    });
                              },
                              //returns a list tile with the title formmatted.

                              title: Text(
                                '\n' + title1,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),

                              subtitle: FadeInImage.assetNetwork(
                                image: image_URL,
                                placeholder: 'assets/images/loading.gif',
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  //if the image fails to load, it will display a placeholder image.
                                  return Image.asset(image_URL);
                                },
                              ),
                            )));
                  });
            } else {
              //if the list has no data, it will return a loading indicator.
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).errorColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

//from documentation https://docs.flutter.dev/cookbook/navigation/passing-data
class ArticlesScreen {
  final String title1;
  final String article_data;

  ArticlesScreen(this.title1, this.article_data);
}

class ExtractArticleData extends StatelessWidget {
  const ExtractArticleData({Key? key}) : super(key: key);
  static const routeName = '/ArticleArguments';

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
        appBar: AppBar(
          title: Text("News",
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.titleLarge),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                  ),
                  child: Text(
                    title.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
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
