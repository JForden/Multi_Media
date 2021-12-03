import 'package:flutter/material.dart';
//literally just a copy of articles page for now, but i deleted the pics so you can tell the difference
class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
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
            ),],
        ),
      ),
    );
  }
}
