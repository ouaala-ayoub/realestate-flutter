import 'package:flutter/cupertino.dart';

class ItemChoiceProvider<T> extends ChangeNotifier {
  ItemChoiceProvider(this.itemsList) : _filtred = itemsList;
  final List<T> itemsList;

  List<T> _filtred;
  List<T> get filtred => _filtred;

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      _filtred = itemsList;
    } else {
      _filtred = itemsList
          .where((item) => item
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
