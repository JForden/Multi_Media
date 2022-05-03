// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "toolbar.dart"; //put your file here
import "articles.dart";
import "home.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArticleData.routeName: (context) => const ExtractArticleData(),
        '/Article': (context) => const newPageData(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 71, 57, 45),
          primaryColorLight: Color.fromARGB(204, 92, 71, 49),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          scaffoldBackgroundColor: Color.fromARGB(255, 246, 245, 244),
          splashColor: Color.fromARGB(255, 248, 152, 28),
          dividerColor: Color.fromARGB(255, 0, 0, 0),
          errorColor: Colors.red,
          textTheme: TextTheme(
              displayLarge: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              displayMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              displaySmall: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.normal,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              headlineLarge: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              headlineMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              headlineSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              titleLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              titleMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              titleSmall: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              bodyLarge: TextStyle(),
              bodyMedium: TextStyle(),
              bodySmall: TextStyle(),
              labelLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              labelMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              ),
              labelSmall: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Helvetica",
                color: Color.fromARGB(255, 71, 57, 45),
              )),
          primaryTextTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            displayMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            displaySmall: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.normal,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            headlineLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            headlineSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            titleMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            titleSmall: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            bodyLarge: TextStyle(),
            bodyMedium: TextStyle(),
            bodySmall: TextStyle(),
            labelLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            labelMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
            labelSmall: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
              color: Color.fromARGB(255, 246, 245, 244),
            ),
          )),
      home: ChangeNotifierProvider<ValueNotifier<int>>.value(
        //Changed this to work with Provider
        value: ValueNotifier<int>(
            2), //PageIndex is set to 0 to open first when when the app launches
        child: MyStatefulWidget(), //put your class here
      ),
    );
  }
}
