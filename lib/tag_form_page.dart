import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'managers/type_manager.dart';

class TagFormPage extends StatefulWidget {
  const TagFormPage({Key? key, this.tagName}) : super(key: key);

  final String? tagName;

  @override
  State<TagFormPage> createState() => _TagFormPageState();
}

class _TagFormPageState extends State<TagFormPage> {

  late final TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController(text: widget.tagName ?? '');
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tag'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tag Name',
                ),
                controller: _tagController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String newTag = _tagController.text.trim();
                  if (newTag.isNotEmpty) {
                    Provider.of<TypeManager>(context, listen: false).addType(newTag); 
                    Navigator.pop(context);
                  }
                },
                child: widget.tagName != null
                  ? const Text('Update Tag')
                  : const Text('Add Tag'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 