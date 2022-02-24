import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    //Builds clickable settings button
    BackButton _buildBackButton(Color color) {
      return BackButton(color: color);
    }

    //Builds Profile title, extra width used to push settings button to the right
    Text _buildDonateTitle(Color color) {
      return Text(
        '88Nine Membership',
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
          _buildDonateTitle(color),
        ],
      ),
    );

    //Current work around for donation page, links to website
    InkWell _donatePageLink(String name, String link) {
      return InkWell(
          hoverColor: Colors.white,
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            Text(
              name,
              style: TextStyle(
                  color: color, fontSize: 24, fontWeight: FontWeight.w600),
            )
          ]),
          onTap: () => launch(link));
    }

    Widget textBox = Container(
      height: deviceHeight * 0.7,
      padding: EdgeInsets.only(left: deviceWidth * .1, right: deviceWidth * .1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _donatePageLink(
              "Donate", "https://radiomilwaukee.org/support-us/membership/"),
          _donatePageLink("Become a Member",
              "https://radiomilwaukee.org/support-us/membership/"),
        ],
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
