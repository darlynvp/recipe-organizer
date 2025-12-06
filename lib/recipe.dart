//recipe variables- a model of a recipe

class Ingredient{
  String name;
  String quantity;

  Ingredient({required this.name, required this.quantity});
}

class Recipe{

  String name;
  String type;
  String servings;
  String cookTime;
  String instructions;
  List<Ingredient> ingredients;
  bool isFavorite;

  Recipe({
    required this.name,
    required this.type,
    required this.servings,
    required this.cookTime,
    required this.instructions,
    required this.ingredients,
    this.isFavorite = false,
  });

}