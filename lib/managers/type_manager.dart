import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recipe_manager.dart';
import '../recipe.dart';

class TypeManager extends ChangeNotifier {

  final List<String> _defaultTypes = [
    'All',
    'Favorites',
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

  void changeType(String oldName, String newName) {
    for (var type in types) {
      if (type == oldName) {
        type = newName;
        notifyListeners();
        break;
      }
    }
  }
}