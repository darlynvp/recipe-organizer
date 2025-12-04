import 'package:flutter/material.dart';

import 'add_recipe_form.dart';
import 'recipe.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key, this.recipe}) : super(key: key);

  final Recipe? recipe;

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Recipe'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AddRecipeForm(recipe: widget.recipe,), 
        ),
      ),
    );
  }
}
