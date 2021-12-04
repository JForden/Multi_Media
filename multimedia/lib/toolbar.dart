import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'playlists.dart';
import "articles.dart"; //put your file here
import "radio.dart"; //put your file here
import "profile.dart";

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<ValueNotifier<int>>.value(
        //Provider allows you to open pages without using the toolbar w/o messing anything up
        value: ValueNotifier<int>(
            0), //PageIndex is set to 0 to open first when when the app launches
        child: MyStatefulWidget(),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = [
    PlaylistPage(),
    RadioPage(),
    RadioPage(),
    ArticlePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    //Changed this to work with Provider
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[Provider.of<ValueNotifier<int>>(context)
          .value], //Changed this to work with Provider
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases_rounded),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'User',
          ),
        ],
        currentIndex: Provider.of<ValueNotifier<int>>(context)
            .value, //Changed this to work with Provider
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
