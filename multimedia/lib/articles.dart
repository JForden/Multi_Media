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
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot snapshot) {
            //calls the getData function from the WpApi class and returns a list of articles.
            if (snapshot.hasData) {
              //if the list has data, it will return a listview of articles.
              var itemCount = snapshot.data.length;
              return ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Since the titles use a version of html, we need to parse it and replace some html tags with their respective strings in order to display the title correctly.
                    String art_data =
                        snapshot.data[index]['content']['rendered'];
                    String title1 = snapshot.data[index]['title']['rendered']
                        .replaceAll('&#8216;', '\'')
                        .replaceAll('&#8217;', '\'')
                        .replaceAll('&#8212;', '-')
                        .replaceAll('&#038;', '&');
                    return ListTile(
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
                        title1,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //the subtitle grabs the photo url from the list and displays it.
                      subtitle: FadeInImage.assetNetwork(
                        image: snapshot.data[index]['_embedded']
                            ['wp:featuredmedia'][0]['source_url'],
                        placeholder: 'assets/images/loading.gif',
                        imageErrorBuilder: (context, error, stackTrace) {
                          //if the image fails to load, it will display a placeholder image.
                          return Image.asset('assets/images/loading.gif');
                        },
                      ),
                    );
                  });
            } else {
              //if the list has no data, it will return a loading indicator.
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
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
    print(title);
    print(content);
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                title.toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Html(
                data: content,
              ),
            ],
          ),
        )));
  }
}
