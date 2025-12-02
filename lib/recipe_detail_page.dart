import 'package:recipeorganizer/recipe.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatefulWidget{

final Recipe recipe;
const RecipeDetailPage({Key? key, required this.recipe}): super(key: key);

@override
State<RecipeDetailPage> createState() => _RecipeDetailPageState();

}

class _RecipeDetailPageState extends State<RecipeDetailPage> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  late List<bool> instructionChecks;
  late List<bool> ingredientChecks;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    List<String> steps = widget.recipe.instructions.contains('\n')
      ? widget.recipe.instructions.split('\n')
      : [widget.recipe.instructions];
    instructionChecks =  List.filled(steps.length, false);
    ingredientChecks = List.filled(widget.recipe.ingredients.length, false);
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final recipe= widget.recipe;

    List<String> instructions = recipe.instructions.contains('\n')
      ? recipe.instructions.split('\n')
      : [recipe.instructions];

      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF21808D),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(recipe.type, style: const TextStyle(fontSize:14, color: Colors.white70 )),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal:16 ),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF21808D),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF21808D),
                tabs: const [
                  Tab(text: 'Stats'),
                  Tab(text: 'Ingredients'),
                  Tab(text: 'Instructions'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _statsTab(recipe),
                  _ingredientsTab(recipe),
                  _instructionsTab(instructions),
                ],
              ),
            ),
          ],
        ),
      );

    
  }

  Widget _infoBox(String label, String value){
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 24),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(label, style: const TextStyle(color: Color(0xFF21808D), fontWeight: FontWeight.w600)),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }

  Widget _statsTab(Recipe recipe){
    return Center(
      child: SizedBox(
        width: 320,
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:32, horizontal: 24 ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Cook time (in minutes)",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF21808D),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  recipe.cookTime,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF134252),
                  ),
                ),
                const SizedBox(height: 34),
                Text(
                  "Servings (per person)",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF21808D),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  recipe.servings,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF134252),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
    
  }
  
  Widget _instructionsTab(List<String> steps) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal:24),
      itemCount: steps.length,
      itemBuilder: (context, i){
        final isChecked = instructionChecks[i];
        return Card(
          color: isChecked ? Colors.grey[300]: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: CheckboxListTile(
            value: isChecked, 
            onChanged: (checked){
              setState(() => instructionChecks[i] = checked ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(steps[i], style: const TextStyle(fontSize: 16)),
            activeColor: const Color(0xFF21808D),
            ),
        );
      },
    );

  }
  
  Widget _ingredientsTab(Recipe recipe) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical:24, horizontal: 24 ),
      itemCount: recipe.ingredients.length,
      itemBuilder: (context,i){
        final ingredient = recipe.ingredients[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: CheckboxListTile(
            value: ingredientChecks[i], 
            onChanged: (checked){
              setState(() => ingredientChecks[i] = checked ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ingredient.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  ingredient.quantity,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF21808D),
                  ),
                )
              ],
            ),
            activeColor: const Color(0xFF21808D),
          ),
        );
      },
    );
  }



}