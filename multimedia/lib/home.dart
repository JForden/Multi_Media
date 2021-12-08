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
      title: 'Home',
      home: Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              width: 250,
              height: 250,
            ),
            mainSection
          ],
        ),
      ),
    );
  }
}

Widget mainSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            FlatButton(
                child: Image.asset('images/newspaper.jpg',
                width: 150,
                height: 150,),
                onPressed: () {},
              ),
              const Text('Featured Article'),
               FlatButton(
                child: 
                Text('Read more...',
                style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                onPressed: () {},
              ),

          ],
        ),
        Column(
          children: [
            FlatButton(
                child: Image.asset('images/podcast.jpg',
                width: 150,
                height: 150,),
                onPressed: () {},
              ),
              const Text('Featured Podcast'),
          ],
        ),
      ],
    );