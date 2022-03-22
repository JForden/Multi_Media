import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'donate.dart';
import 'help.dart';
import 'shop.dart';
import 'settings.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    //Builds clickable big buttons
    InkWell _buildBigButton(
        Color color, IconData icon, String text, Widget page) {
      return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
            //Provider.of<ValueNotifier<int>>(context, listen: false).value =
            //    1; //This is a test case
          },
          child: Container(
              width: deviceWidth * 0.9,
              height: deviceHeight * 0.1,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: deviceHeight * 0.08),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: deviceHeight * 0.035,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              )));
    }

    InkWell _buildLinkButton(
        Color color, IconData icon, String text, String link) {
      return InkWell(
          onTap: () => launch(link),
          child: Container(
              width: deviceWidth * 0.9,
              height: deviceHeight * 0.1,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: deviceHeight * 0.08),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: deviceHeight * 0.035,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              )));
    }

    //Builds clickable settings button
    InkWell _buildSettingsButton(Color color, IconData icon, Widget page) {
      return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Container(
              width: deviceHeight * 0.045,
              height: deviceHeight * 0.045,
              child: Icon(icon, color: color, size: deviceHeight * 0.045)));
    }

    //Builds Profile title, extra width used to push settings button to the right
    Text _buildProfileTitle(Color color) {
      return Text(
        'Profile',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: deviceHeight * 0.06,
          fontWeight: FontWeight.bold,
          fontFamily: "Helvetica",
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
          _buildProfileTitle(color),
          _buildSettingsButton(color, Icons.settings, SettingsPage())
        ],
      ),
    );

    Widget bigButtons = Container(
        width: deviceWidth,
        height: deviceHeight * 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLinkButton(color, Icons.star, 'Support Us',
                "https://radiomilwaukee.org/support-us/membership/"),
            _buildLinkButton(color, Icons.shopping_bag, 'Shop',
                "https://radiomilwaukee.org/shop/"),
            _buildBigButton(color, Icons.help, 'Help', HelpPage()),
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
