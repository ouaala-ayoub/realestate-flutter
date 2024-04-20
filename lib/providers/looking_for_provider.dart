import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/helpers/posts_helper.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/providers/loader_provider.dart';
import 'package:realestate/views/looking_for_advert_steps/looking_for_advert.dart';
import 'package:realestate/views/post_advert_steps/location_step.dart';

class LookingForProvider extends LoaderProvider {
  // final formKey = GlobalKey<FormState>();

  final List<bool> _canContinue = [false, false];
  @override
  List<bool> get canContinue => _canContinue;

  bool _loading = false;
  @override
  bool get loading => _loading;

  final List<Widget> _steps = [
    const LookingForAdvertStepOne(),
    Consumer<LookingForProvider>(
      builder: ((context, provider, child) {
        final searchProvider = context.read<SearchProvider>();
        return LocationStepBody(
            searchProvider: searchProvider, loaderProvider: provider);
      }),
    )
  ];
  @override
  List<Widget> get steps => _steps;

  final Map<String, dynamic> _data = {
    'country': null,
    'city': TextEditingController(),
    'area': TextEditingController(),
    'description': TextEditingController(),
    'category': null,
    'phoneCode': null,
    'phoneFlag': null,
    'phoneNumber': TextEditingController(),
    'contactPhone': false,
    'contactWhatsapp': false,
  };
  @override
  Map<String, dynamic> get data => _data;

  @override
  submitPost(
      {required String ownerId,
      Function(dynamic p1)? onStart,
      required Function(dynamic res) onSuccess,
      required Function(dynamic e) onFail}) async {
    _loading = true;
    notifyListeners();

    final res = await PostsHelper().lookingForAdvert(data, ownerId);
    res.fold((e) => onFail(e), (res) => onSuccess(res));

    _loading = false;
    notifyListeners();
  }

  @override
  updateNextStatus() {
    //fancy way to get the value of && of all elements
    // final stepsComplete =
    //     canContinue.reduce((value, element) => value & element);

    final stepsComplete = canContinue[0];
    final newValue = _data['country'] != null &&
        isFieldNotEmpty('city') &&
        isFieldNotEmpty('description');

    _canContinue[1] = newValue && stepsComplete;
    notifyListeners();
  }

  isFieldNotEmpty(String field) => _data[field].text.isNotEmpty;

  @override
  setCountry(String name) {
    _data['country'] = name;
    updateNextStatus();
  }

  @override
  setFields(List<String> keys, List<dynamic> values) {
    for (var key in keys.indexed) {
      _data[key.$2] = values[key.$1];
    }
    updateNextStatus1();
  }

  @override
  void updateNextStatus1() {
    _canContinue[0] = _data['category'] != null &&
        _data['phoneCode'] != null &&
        _data['phoneNumber'].text.isNotEmpty != null &&
        (_data['contactPhone'] || _data['contactWhatsapp']);
    notifyListeners();
  }
}
