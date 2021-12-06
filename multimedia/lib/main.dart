import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "toolbar.dart"; //put your file here

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<ValueNotifier<int>>.value(
        //Changed this to work with Provider
        value: ValueNotifier<int>(
            2), //PageIndex is set to 0 to open first when when the app launches
        child: MyStatefulWidget(), //put your class here
      ),
    );
  }
}
