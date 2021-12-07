import 'dart:io';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFF)),
      title: 'Home',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/logo.jpg',
              width: 200,
              height: 200,
            ),
            midSection,
            textSection,
          ],
        ),
      ),
    );
  }
  Widget midSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
              alignment: Alignment.center,
              child: 
              FlatButton(
                child: Image.asset('images/newspaper.jpg',
                width: 200,
                height: 200,),
                onPressed: () {},
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: 
              FlatButton(
                child: Image.asset('images/podcast.jpg',
                width: 200,
                height: 200,),
                onPressed: () {},
              ),
            ),
            
      ],
    );

    Widget textSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
              alignment: Alignment.center,
              child: 
             Text(
                "Featured Article",
                textAlign: TextAlign.center,
               ),
            ),
            Container(
              alignment: Alignment.center,
              child: 
               Text(
                "Featured Podcast",
                textAlign: TextAlign.center,
               ),
            ),  
            ],
    );
}