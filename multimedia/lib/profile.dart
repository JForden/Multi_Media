import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Container _buildBigButton(Color color, IconData icon, String text) {
      return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 64),
              Container(
                constraints: BoxConstraints(minWidth: 110, maxWidth: 110),
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  softWrap: true,
                ),
              )
            ],
          ));
    }

    Padding _buildBigRows(Container button1, Container button2) {
      return Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              button1,
              button2,
            ],
          ));
    }

    Color color = Color.fromARGB(255, 71, 57, 45);

    Widget topBar = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Profile    Settings!',
        softWrap: true,
      ),
    );

    Widget bigButtons = Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBigRows(_buildBigButton(color, Icons.star, 'Donate'),
                _buildBigButton(color, Icons.star, 'Become a Member')),
            _buildBigRows(_buildBigButton(color, Icons.shopping_bag, 'Shop'),
                _buildBigButton(color, Icons.help, 'Help')),
          ],
        ));

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
