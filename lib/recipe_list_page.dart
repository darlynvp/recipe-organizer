import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeorganizer/data.dart';

import 'recipe_manager.dart';
import 'recipe_detail_page.dart';
import 'recipe.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {

  @override
  Widget build(BuildContext context) {

    List<Recipe> recipes = context.watch<RecipeManager>().recipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Your Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200),
          margin: const EdgeInsets.only(top: 4),
          child: ListView.builder(
            itemCount: recipes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                color: Colors.white,
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(recipe.type),
                  
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (recipe.isFavorite)
                        const Icon(Icons.favorite, color: Colors.red),
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                ),
                
              );
            },
          ),
        ),
      ),
    );
  }
}