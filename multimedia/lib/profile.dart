import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Color color = Color.fromARGB(255, 71, 57, 45);

    Widget topBar = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Settings',
        softWrap: true,
      ),
    );
    Widget bigButtons = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Buttons!',
        softWrap: true,
      ),
    );

    return Scaffold(
      body: ListView(
        children: [
          topBar,
          bigButtons,
        ],
      ),
    );
  }
}
