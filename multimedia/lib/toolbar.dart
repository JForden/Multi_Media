import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      title: _title,
      home: ChangeNotifierProvider<ValueNotifier<int>>.value(
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
    //these are out of order but you get the idea
    ArticlePage(), //this should be playlists
    RadioPage(),
    RadioPage(), //this should be home
    ArticlePage(),
    ProfilePage(), //this should be user/donations
  ];

  void _onItemTapped(int index) {
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: _widgetOptions[Provider.of<ValueNotifier<int>>(context).value],
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
        currentIndex: Provider.of<ValueNotifier<int>>(context).value,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
