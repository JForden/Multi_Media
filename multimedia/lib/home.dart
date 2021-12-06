import 'package:flutter/material.dart';

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