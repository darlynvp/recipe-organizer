import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipeorganizer/recipe.dart';
import 'package:recipeorganizer/recipe_manager.dart';

import 'data.dart';

class AddRecipeForm extends StatefulWidget {
  const AddRecipeForm({Key? key, this.recipe}) : super(key: key);

  final Recipe? recipe;

  @override
  State<AddRecipeForm> createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {

  late TextEditingController nameC;
  late TextEditingController servingsC;
  late TextEditingController cookTimeC;
  late TextEditingController instructionsC;
  late List<Ingredient> ingredients;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.recipe?.name ?? '');
    servingsC = TextEditingController(text: widget.recipe?.servings ?? '');
    cookTimeC = TextEditingController(text: widget.recipe?.cookTime ?? '');
    instructionsC = TextEditingController(text: widget.recipe?.instructions ?? '');
    
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

  final _formKey = GlobalKey<FormState>();
  String? _selectedValue = chips[0];

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal
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
                  const Text(
                    'Your New Recipe...',
                    style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(  
                    controller: nameC,                // Recipe name input
                    decoration: const InputDecoration(
                      labelText: 'Recipe Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a recipe name';
                      }
                      return null;
                    },
                  ),
                  Divider(height: 32),
                  DropdownButtonFormField(        // Category selection
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    initialValue: _selectedValue,
                    items: chips.map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
                  Divider(height: 32),
                  TextFormField(   
                    controller: servingsC,             // Serving size input
                    decoration: const InputDecoration(
                      labelText: 'Serving Size',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a serving size';
                      }
                      return null;
                    },
                  ),
                  Divider(height: 32),
                  TextFormField(
                    controller: cookTimeC,
                    decoration: const InputDecoration(
                      labelText: 'Prep/Cook Time',
                    ),
                  ),
                  Divider(height: 32),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Text(
                              'Ingredients: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10,),
                            ...ingredients.map((ingredient) => IngredientInput(
                              ingredient: ingredient,
                              onDelete: () {
                                if (ingredients.length <= 1) return;
                                setState(() {
                                  ingredients.remove(ingredient);
                                });
                              },
                            )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      ingredients.add(Ingredient(name: '', quantity: ''));
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(7.0, 0, 10.0, 0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.add),
                                      SizedBox(width: 4),
                                      Text('Add'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 32),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                    TextFormField(
                      controller: instructionsC,
                      decoration: const InputDecoration(
                        hintText: 'Enter the instructions of your recipe \nSeparate with Enter',
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 24),
                  
                  if (widget.recipe != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process data
                            final newRecipe = Recipe(
                              name: nameC.text,
                              type: _selectedValue ?? '',
                              servings: servingsC.text,
                              cookTime: cookTimeC.text,
                              ingredients: ingredients,
                              instructions: instructionsC.text,
                            );
                            Provider.of<RecipeManager>(context, listen:false).changeRecipe(widget.recipe!, newRecipe);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    )
                  ] else ...[
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          final newRecipe = Recipe(
                            name: nameC.text,
                            type: _selectedValue ?? '',
                            servings: servingsC.text,
                            cookTime: cookTimeC.text,
                            ingredients: ingredients,
                            instructions: instructionsC.text,
                          );
                          Provider.of<RecipeManager>(context, listen:false).addRecipe(newRecipe);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ),
                  ],

                  
                ],
              ),
            ),
          )
        )
      ),
    );
  }

@override
void dispose(){
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
  const IngredientInput({Key? key, required this.ingredient, required this.onDelete}) : super(key: key);

  @override
  State<IngredientInput> createState() => _IngredientInputState();
} 

class _IngredientInputState extends State<IngredientInput> {
  late TextEditingController nameController;
  late TextEditingController quantityController;

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: widget.ingredient.name);
    quantityController = TextEditingController(text:widget.ingredient.quantity);
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an ingredient name';
                }
                return null;
              },
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                return null;
              },
              onChanged: (value) => widget.ingredient.quantity = value,
            ),
          ),
          IconButton(
            onPressed: widget.onDelete, 
            icon: Icon(Icons.delete),
            iconSize: 20,
            padding: EdgeInsets.all(0),
          ),
        ],
      ),
      SizedBox(height: 10,),
      ],
    );
  }

  @override
  void dispose(){
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
