import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipeorganizer/recipe.dart';
import 'package:recipeorganizer/recipe_manager.dart';

import 'data.dart';
import 'managers/type_manager.dart';

class AddRecipeForm extends StatefulWidget {
  const AddRecipeForm({
    Key? key,
    this.recipe,
    required this.isFavorite,
    required this.onFavoriteChanged,
  }) : super(key: key);

  final Recipe? recipe;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  @override
  State<AddRecipeForm> createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  late TextEditingController nameC;
  late TextEditingController servingsC;
  late TextEditingController cookTimeC;
  late TextEditingController instructionsC;
  late List<Ingredient> ingredients;
  late List<String> chips;

  final _formKey = GlobalKey<FormState>();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();

    nameC = TextEditingController(text: widget.recipe?.name ?? '');
    servingsC = TextEditingController(text: widget.recipe?.servings ?? '');
    cookTimeC = TextEditingController(text: widget.recipe?.cookTime ?? '');
    instructionsC =
        TextEditingController(text: widget.recipe?.instructions ?? '');

    if (widget.recipe != null) {
      ingredients = widget.recipe!.ingredients
          .map((ingredient) => Ingredient(
                name: ingredient.name,
                quantity: ingredient.quantity,
              ))
          .toList();
    } else {
      ingredients = [Ingredient(name: '', quantity: '')];
    }
  }

  @override
  Widget build(BuildContext context) {
    chips = context.watch<TypeManager>().types;
    _selectedValue ??= chips.isNotEmpty ? chips.first : null;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.teal, width: 3),
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Recipe Name
                  TextFormField(
                    controller: nameC,
                    decoration: const InputDecoration(
                      labelText: 'Recipe Name',
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a recipe name'
                            : null,
                  ),

                  const Divider(height: 32),

                  // Serving size
                  TextFormField(
                    controller: servingsC,
                    decoration: const InputDecoration(
                      labelText: 'Serving size',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a serving size'
                            : null,
                  ),

                  const Divider(height: 32),

                  // Cook Time
                  TextFormField(
                    controller: cookTimeC,
                    decoration: const InputDecoration(
                      labelText: 'Prep/Cook Time',
                    ),
                  ),

                  const Divider(height: 32),

                  // Category Dropdown
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    value: _selectedValue,
                    items: chips
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value as String?;
                      });
                    },
                  ),

                  const Divider(height: 32),

                  // Ingredients
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...ingredients.map(
                          (ingredient) => IngredientInput(
                            ingredient: ingredient,
                            onDelete: () {
                              if (ingredients.length <= 1) return;
                              setState(() {
                                ingredients.remove(ingredient);
                              });
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  ingredients.add(
                                    Ingredient(name: '', quantity: ''),
                                  );
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.fromLTRB(7, 0, 10, 0),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 4),
                                  Text('Add'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 32),

                  // Instructions
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextFormField(
                    controller: instructionsC,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Enter the instructions of your recipe\nSeparate with Enter',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save / Create button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        final newRecipe = Recipe(
                          name: nameC.text,
                          type: _selectedValue ?? '',
                          servings: servingsC.text,
                          cookTime: cookTimeC.text,
                          ingredients: ingredients,
                          instructions: instructionsC.text,
                          isFavorite: widget.isFavorite,
                        );

                        if (widget.recipe != null) {
                          Provider.of<RecipeManager>(context, listen: false)
                              .changeRecipe(widget.recipe!, newRecipe);

                          Navigator.pop(context, newRecipe);
                        } else {
                          Provider.of<RecipeManager>(context, listen: false)
                              .addRecipe(newRecipe);

                          Navigator.pop(context);
                        }
                      },
                      child: Text(widget.recipe != null ? 'Save' : 'Create'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameC.dispose();
    servingsC.dispose();
    cookTimeC.dispose();
    instructionsC.dispose();
    super.dispose();
  }
}

class IngredientInput extends StatefulWidget {
  final Ingredient ingredient;
  final VoidCallback onDelete;

  const IngredientInput({
    Key? key,
    required this.ingredient,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends State<IngredientInput> {
  late TextEditingController nameController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.ingredient.name);
    quantityController =
        TextEditingController(text: widget.ingredient.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ingredient Name',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Please enter an ingredient name'
                        : null,
                onChanged: (value) => widget.ingredient.name = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Please enter a quantity'
                        : null,
                onChanged: (value) =>
                    widget.ingredient.quantity = value,
              ),
            ),
            IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete),
              iconSize: 20,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
