import 'package:flutter/cupertino.dart';

abstract class LoaderProvider extends ChangeNotifier {
  late bool loading;
  late List<bool> canContinue;
  late List<Widget> steps;
  late Map<String, dynamic> data;

  submitPost(
      {required String ownerId,
      Function(dynamic)? onStart,
      required Function(dynamic) onSuccess,
      required Function(dynamic) onFail});

  updateNextStatus();
  updateNextStatus1();

  setCountry(String name);

  void setFields(List<String> keys, List<dynamic> values) {}
}
