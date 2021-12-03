import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "toolbar.dart"; //put your file here

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<ValueNotifier<int>>.value(
        value: ValueNotifier<int>(
            0), //PageIndex is set to 0 to open first when when the app launches
        child: MyStatefulWidget(), //put your class here
      ),
    );
  }
}
