import 'package:flutter/material.dart';
//literally just a copy of articles page for now, but i deleted the pics so you can tell the difference
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geeks for Geeks'),
        backgroundColor: Colors.green,
      ),
      body: Center(
          child: Column(
          children: <Widget>[
          RaisedButton(
            child: Text('Click Me!'),
            onPressed: () {
              /* Contains the code that helps us
             navigate to the second route. */
            },
          ),
          RaisedButton(
            child: Text('Tap Me!'),
            onPressed: () {
              /* Contains the code that helps us
             navigate to the third route. */
            },
          ),
        ],
      )),
    );
  }
}