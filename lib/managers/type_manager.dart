import 'package:flutter/cupertino.dart';

class TypeManager extends ChangeNotifier {

  final List<String> _defaultTypes = [
    'All',
    'Favorites',
  ];

  late List<String> types = [];

  TypeManager() {
    _initializeTypes();
  }

  void _initializeTypes() {
    types = List.from(_defaultTypes);
  }

  void addType(String typeName) {
    bool hasType = types.any((type) => type == typeName);
    if (!hasType) {
      types.add(typeName);
      notifyListeners();
    }
  }
  void removeType(String typeName) {
    types.removeWhere((type) => type == typeName);
    notifyListeners();
  }

  void changeType(String oldName, String newName) {
    for (var type in types) {
      if (type == oldName) {
        type = newName;
        notifyListeners();
        break;
      }
    }
  }
}