import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeorganizer/recipe.dart';
import 'package:recipeorganizer/recipe_manager.dart';
import 'package:recipeorganizer/recipe_detail_page.dart';

import 'add_recipe_page.dart';
import 'profile_page.dart';
import 'data.dart';
import 'recipe_list_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedChip = 0;
  int _selectedNav = 0;
  final TextEditingController _searchController = TextEditingController();

  bool get _isSearchActive =>
    _searchController.text.trim().isNotEmpty;

String get _selectedType => chips[_selectedChip]; 

  bool _matchSearch(Recipe recipe) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return true;
    return recipe.name.toLowerCase().contains(query);
  }
  bool _matchType(Recipe recipe) {
    final type = _selectedType;

    if (type == "All") return true;
     
    if(type == 'Favorites'){
      return recipe.isFavorite == true;
    }

    return recipe.type == type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildSearchResults(),
                    const SizedBox(height: 8),
                    _buildFilterChips(),
                    const SizedBox(height: 20),
                    _buildFeaturedSection(),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context),
                    const SizedBox(height: 16),
                    _buildRecipeGrid(),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Welcome!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF626C71),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {}); 
      },
      decoration: InputDecoration(
        hintText: 'Search recipe',
        hintStyle: const TextStyle(color: Color(0xFF626C71)),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF626C71)),
        filled: true,
        fillColor: const Color(0xFFFCFCF9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF21808D)),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final isActive = _selectedChip == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (chips[index]== 'Favorites') const Text('❤️ '),
                  Text(chips[index]),
                ],
              ),
              selected: isActive,
              // rebuild when chip changes
              onSelected: (selected) {
                setState(() => _selectedChip = index);
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF21808D),
              labelStyle: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF134252),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isActive
                    ? const Color(0xFF21808D)
                    : Colors.grey.withOpacity(0.3),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
        image: const DecorationImage(
          image: NetworkImage(
            'https://img.freepik.com/free-vector/cartoon-style-recipe-note-with-ingredients_52683-79718.jpg?semt=ais_hybrid&w=740&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.3),
        ),
        child: const Center(
          child: Text(
            'Recipe\nArchive',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recipes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF134252),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios), 
          iconSize: 16, 
          color: Colors.grey, 
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecipeListPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecipeGrid() {
  return SizedBox(
    height: 220,
    child: Consumer<RecipeManager>(
      builder: (context, manager, child) {
        final allRecipes = manager.recipes;

        // If user is typing, show only search matches (override chips)
        final filtered = _isSearchActive
            ? allRecipes.where(_matchSearch).toList()
            : allRecipes.where((r) => _matchSearch(r) && _matchType(r)).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              'No recipes found',
              style: TextStyle(color: Color(0xFF626C71)),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final recipe = filtered[index];

            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                print("Opening recipe: ${recipe.name}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(recipe: recipe),
                  ),
                );
              },
              child: Container(
                width: 160,
                margin:
                    const EdgeInsets.only(right: 12, bottom: 6, top: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            recipe.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF134252),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 6, left: 8, right: 8),
                      child: Column(
                        children: [
                          Text(
                            recipe.type,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF626C71),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recipe.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF134252),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF21808D),
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.add_circle_outline, 1),
          _buildNavItem(Icons.person_outline, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedNav == index;

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipePage()),
          ).then(
            (_) => setState(() {
              _selectedNav = 0;
            }),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          ).then(
            (_) => setState(() {
              _selectedNav = 0;
            }),
          );
          index = 0;
        } else {
          setState(() => _selectedNav = index);
        }
      },
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? const Color(0xFF64FFDA) : Colors.white,
      ),
    );
  }

  Widget _buildSearchResults() {
    if(!_isSearchActive) return const SizedBox.shrink();

    return Consumer<RecipeManager>(
      builder: (context, manager,child){
        final matches = manager.recipes
            .where(_matchSearch)
            .take(5)
            .toList();

        if (matches.isEmpty){
          return const SizedBox.shrink();
        }

        return Container(
          constraints: const BoxConstraints(maxHeight: 200),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: matches.length,
            itemBuilder: (context,index){
              final recipe = matches[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text(recipe.type),
                onTap: (){
                  _searchController.text = recipe.name;
                  FocusScope.of(context).unfocus();
                  setState(() { });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailPage(recipe: recipe),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
    

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}