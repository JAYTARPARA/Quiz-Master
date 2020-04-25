import 'package:flutter/material.dart';
import 'package:quizzmaster/ui/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Master',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.blue,
        fontFamily: "Montserrat",
        buttonColor: Colors.orange,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: HomePage(),
    );
  }
}
