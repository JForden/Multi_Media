import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.network(
                'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg',
                width: 200.0,
              ),
            ),
            Text('Example Article Link 1',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Image.network(
                'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg'),
            Text('Example Article Link 2',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Image.network(
                'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg'),
            Text('Example Article Link 3',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Image.network(
                'https://s3.amazonaws.com/libapps/accounts/9189/images/newspaper.jpg'),
            Text('Example Article Link 4',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
