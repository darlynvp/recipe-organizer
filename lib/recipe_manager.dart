//stores all recipes added by user
//recipes added will also be displayed to main page

import 'package:flutter/material.dart';
import 'package:recipeorganizer/recipe.dart';
import 'package:provider/provider.dart';

class RecipeManager extends ChangeNotifier{

  final List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  void addRecipe(Recipe recipe){

    _recipes.add(recipe);
    notifyListeners();
  }

  void toggleFavorite(Recipe recipe){
    recipe.isFavorite = !recipe.isFavorite;
    notifyListeners();
  }

  void changeRecipe(Recipe oldRecipe,Recipe updatedRecipe){
    int index = _recipes.indexOf(oldRecipe);
    if(index != -1){
      _recipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

}