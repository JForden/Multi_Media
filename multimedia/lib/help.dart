import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    //Builds clickable settings button
    BackButton _buildBackButton(Color color) {
      return BackButton(color: color);
    }

    //Builds Profile title, extra width used to push settings button to the right
    Text _buildHelpTitle(Color color) {
      return Text(
        'Help',
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.titleMedium,
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
          _buildHelpTitle(color),
        ],
      ),
    );

    Widget textBox = Container(
      height: deviceHeight * 0.7,
      padding: EdgeInsets.only(left: deviceWidth * .1, right: deviceWidth * .1),
      child: Text(
        'Lots of really really long text,' +
            'Lots of really really long text,' +
            'Lots of really really long text,' +
            'Lots of really really long text,' +
            'Lots of really really long text,' +
            'Lots of really really long text,' +
            'Lots of really really long text,' +
            'Lots of really really long text,' +
            'Lots of really really long text,',
        style: Theme.of(context).textTheme.bodyLarge,
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
