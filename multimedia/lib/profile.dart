import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    //Builds clickable big buttons
    InkWell _buildBigButton(Color color, IconData icon, String text) {
      return InkWell(
          onTap: () {
            Provider.of<ValueNotifier<int>>(context, listen: false).value =
                1; //This is a test case
          },
          child: Container(
              width: 132,
              height: 132,
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
              )));
    }

    //Builds clickable settings button
    InkWell _buildSettingsButton(Color color, IconData icon) {
      return InkWell(
          onTap: () {
            Provider.of<ValueNotifier<int>>(context, listen: false).value =
                1; //This is a test case
          },
          child: Container(
              width: 24,
              height: 24,
              child: Icon(icon, color: color, size: 32)));
    }

    //Builds Profile title, extra width used to push settings button to the right
    Container _buildProfileTitle(Color color) {
      return Container(
        width: 300,
        child: Text(
          'Profile',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      );
    }

    //Puts big buttons into rows
    Container _buildBigRows(InkWell button1, InkWell button2) {
      return Container(
          width: 400,
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

    //88Nine Brown (tm)
    Color color = Color.fromARGB(255, 71, 57, 45);

    Widget topBar = Padding(
      padding: EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildProfileTitle(color),
          _buildSettingsButton(color, Icons.settings)
        ],
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
