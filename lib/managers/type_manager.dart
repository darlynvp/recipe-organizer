import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'recipe_manager.dart';
import '../recipe.dart';

class TypeManager extends ChangeNotifier {

  final List<String> _defaultTypes = [
    'All',
  ];

  late List<String> types = [];

  TypeManager() {
    _initializeTypes();
  }

  void _initializeTypes() {
    types = List.from(_defaultTypes);
  }

  void addType(String typeName) {
    bool hasType = types.any((type) => type == typeName);
    if (!hasType) {
      types.add(typeName);
      notifyListeners();
    }
  }
  void removeType(BuildContext context, String typeName) {
    types.removeWhere((type) => type == typeName);

    final List<Recipe> _recipes = context.read<RecipeManager>().recipes;
    for (var recipe in _recipes) {
      if (recipe.type == typeName) {
        context.read<RecipeManager>().updateRecipeType(recipe, 'All');
      }
    }
    notifyListeners();
  }

  void changeType(BuildContext context, String oldName, String newName) {

    final List<Recipe> _recipes =  context.read<RecipeManager>().recipes;

    for (int i = 0; i < types.length; i++) {
      if (types[i] == oldName) {
        types[i] = newName;
        break;
      }
    }
    notifyListeners();

    for (var recipe in _recipes) {
      if (recipe.type == oldName) {
        context.read<RecipeManager>().updateRecipeType(recipe, newName);
      }
    }

  }
}