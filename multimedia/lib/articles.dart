import 'package:flutter/material.dart';
import 'wp_api.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
  // _ArticlePageState2 createState2() => _ArticlePageState2();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var itemCount = snapshot.data.length;
              return ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    String title1 = snapshot.data[index]['title']['rendered']
                        .replaceAll('&#8216;', '\'')
                        .replaceAll('&#8217;', '\'')
                        .replaceAll('&#8212;', '-')
                        .replaceAll('&#038;', '&');
                    return ListTile(
                      title: Text(
                        title1,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: FadeInImage.assetNetwork(
                        image: snapshot.data[index]['_embedded']
                            ['wp:featuredmedia'][0]['source_url'],
                        placeholder: 'assets/images/loading.gif',
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/loading.gif');
                        },
                      ),
                    );
                  });
            } else {
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
