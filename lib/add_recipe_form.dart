import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';


class AddRecipeForm extends StatefulWidget {
  const AddRecipeForm({Key? key}) : super(key: key);

  @override
  State<AddRecipeForm> createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {

  final _formKey = GlobalKey<FormState>();
  String? _selectedValue = chips[0];
  List<Ingredient> ingredients = [Ingredient(name: '', quantity: '')];

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(                  // Recipe name input
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
                DropdownButtonFormField(        // Category selection
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
                TextFormField(                // Serving size input
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process data
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }

}

class IngredientInput extends StatefulWidget {
  const IngredientInput({Key? key, required this.ingredient, required this.onDelete}) : super(key: key);
  final Ingredient ingredient;
  final VoidCallback onDelete;

  @override
  State<IngredientInput> createState() => _IngredientInputState();
} 

class _IngredientInputState extends State<IngredientInput> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ingredient Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an ingredient name';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Quantity',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a quantity';
              }
              return null;
            },
          ),
        ),
        IconButton(onPressed: widget.onDelete, icon: Icon(Icons.delete))
      ],
    );
  }
}

class Ingredient {
  String name;
  String quantity;

  Ingredient({required this.name, required this.quantity});
}