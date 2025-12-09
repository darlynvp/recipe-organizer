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

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context ,index){
                  final recipe = favorites[index];
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Text(recipe.type),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailPage(recipe:  recipe),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
        },
      )
    );
  }

}