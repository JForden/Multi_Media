import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "toolbar.dart"; //put your file here
import "articles.dart";
import "home.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArticleData.routeName: (context) => const ExtractArticleData(),
        '/Article': (context) => const newPageData(),
      },
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
