import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeorganizer/main_page.dart';
import 'package:recipeorganizer/recipe_manager.dart';
import 'package:recipeorganizer/managers/type_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipeManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => TypeManager(),
        ),
      ],
      child: RecipeApp(),
    )
  );
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




