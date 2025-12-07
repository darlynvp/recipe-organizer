import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recipe_manager.dart';
import 'recipe.dart';
import 'recipe_detail_page.dart';

class FavoritesPage extends StatelessWidget{

  const FavoritesPage({Key ? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: Consumer<RecipeManager>(
        builder: (context, manager, child){
          final favorites = manager.recipes
            .where((r) => r.isFavorite == true)
            .toList();

            if(favorites.isEmpty){
              return const Center(child: Text("No Favorite recipes"));
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context ,index){
                final recipe = favorites[index];
                return ListTile(
                  title: Text(recipe.name),
                  subtitle: Text(recipe.type),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailPage(recipe:  recipe),
                      ),
                    );
                  },
                );
              },
            );
        },
      )
    );
  }

}