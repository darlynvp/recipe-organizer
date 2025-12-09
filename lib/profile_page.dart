import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'recipe_manager.dart';
import 'package:provider/provider.dart';
import 'tag_form_page.dart';
import 'managers/type_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final TextEditingController _tagController;

  @override 
  void initState() {
    super.initState();
    _tagController = TextEditingController();
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int recipeCount = context.watch<RecipeManager>().recipes.length;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cookbook'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            recipeCount.toString(),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),  
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Recipes Stored',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Divider(
                    thickness: 2,
                    color: Colors.teal.shade400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),

                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Manage Your Tags',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _showDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text('Add New Tag')
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: context.watch<TypeManager>().types.length,
                              itemBuilder: (context, index) {
                                String tag = context.watch<TypeManager>().types[index];
                                if (['All'].contains(tag)) {
                                  return SizedBox.shrink();
                                } else {
                                  return Card(
                                    child: ListTile(
                                      title: Text(tag),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Provider.of<TypeManager>(context, listen:false).removeType(context, tag);
                                            }, 
                                            icon: Icon(Icons.delete)
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              _tagController.text = tag;
                                              _showDialog(oldTagName: tag);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],  
            ),
        ),
    );
  }

  void _showDialog({String? oldTagName}) {
    showDialog(
      context: context, 
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
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
          child: Dialog(
            child: SizedBox(
              height: 175,
              width: 400,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ...(_tagController.text != "" 
                    ? [
                      Text(
                        'Edit Tag',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ] 
                    : [
                      Text(
                        'Add Tag',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  
                  Padding(
                    padding: const EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Tag Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Future.delayed(Duration(milliseconds: 300), () {
                            _tagController.clear();
                          });
                        }, 
                        child: Text('Cancel')
                      ),
                      SizedBox(width: 10),

                      TextButton(
                        onPressed: () {
                          String newTag = _tagController.text.trim();
                          if (oldTagName == null || oldTagName.isEmpty || oldTagName == "") {
                            Provider.of<TypeManager>(context, listen: false).addType(newTag);
                          } else {
                            Provider.of<TypeManager>(context, listen: false).changeType(context, oldTagName!, newTag);
                          }
                          Navigator.of(context).pop();
                        }, 
                        child: (_tagController.text != "" ? Text('Update') : Text('Add'))
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    ).then((result) {
      Future.delayed(Duration(milliseconds: 300), () {
        _tagController.clear();
      });
    });
  }
}