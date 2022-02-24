import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    //Builds clickable settings button
    BackButton _buildBackButton(Color color) {
      return BackButton(color: color);
    }

    //Builds Profile title, extra width used to push settings button to the right
    Text _buildSettingsTitle(Color color) {
      return Text(
        'Settings',
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: deviceHeight * 0.035,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      );
    }

    //88Nine Brown (tm)
    Color color = Color.fromARGB(255, 71, 57, 45);

    Widget topBar = Container(
      width: deviceWidth * 0.9,
      height: deviceHeight * 0.1,
      padding:
          EdgeInsets.only(left: deviceWidth * .05, right: deviceWidth * .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(color),
          _buildSettingsTitle(color),
        ],
      ),
    );

    Widget textBox = Container(
      height: deviceHeight * 0.7,
      padding: EdgeInsets.only(left: deviceWidth * .1, right: deviceWidth * .1),
      child: Text(
        'Login/Logout\n' +
            'Add Music Streaming Service\n' +
            'Notifications\n' +
            'About\n',
        style:
            TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      body: ListView(
        children: [
          topBar,
          textBox,
        ],
      ),
    );
  }
}
