import 'package:flutter/material.dart';
import 'package:recipeorganizer/main_page.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Organizer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color((0xFFB3D9D9)),
        fontFamily: 'SF Pro'
        ),
        home: const MainPage(),//main page of the app
        );
  }
}




