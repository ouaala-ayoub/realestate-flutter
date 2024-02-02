import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/models/helpers/posts_helper.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/loader_provider.dart';
import 'package:realestate/views/post_advert_steps/details_step.dart';
import '../main.dart';
import '../views/post_advert_steps/images_step.dart';
import '../views/post_advert_steps/location_step.dart';
import '../views/post_advert_steps/property_info_step.dart';

class PostAdvertProvider extends LoaderProvider {
  static final _helper = PostsHelper();

  final List<bool> _canContinue = [false, false, false];
  @override
  List<bool> get canContinue => _canContinue;

  bool _loading = false;
  @override
  bool get loading => _loading;

  final _steps = [
    const PostAdvertImagesStep(),
    Consumer<PostAdvertProvider>(builder: ((context, provider, child) {
      final searchProvider = context.read<SearchProvider>();
      return LocationStepBody(
          searchProvider: searchProvider, loaderProvider: provider);
    })),
    const PropretyInfoStep(),
  ];
  @override
  List<Widget> get steps => _steps;

  final Map<String, dynamic> _data = {
    'media': [],
    'country': null,
    'city': TextEditingController(),
    'area': TextEditingController(),
    'description': TextEditingController(),
    'type': null,
    'category': null,
    'price': TextEditingController(),
    'period': null,
    'phoneCode': null,
    'phoneFlag': null,
    'phoneNumber': TextEditingController(),
    'contactPhone': false,
    'contactWhatsapp': false,
    'condition': null,
    'numRooms': TextEditingController(),
    'numBathrooms': TextEditingController(),
    'floorNumber': TextEditingController(),
    'floors': TextEditingController(),
    'm2': TextEditingController(),
    'foot2': TextEditingController(),
    'features': []
  };
  @override
  Map<String, dynamic> get data => _data;

  // final Map<String, String?> error = {'country': null};

  @override
  void submitPost(
      {required String ownerId,
      Function(dynamic)? onStart,
      required Function(dynamic) onSuccess,
      required Function(dynamic) onFail}) async {
    _loading = true;
    notifyListeners();
    final res = await _helper.postAdvert(data, ownerId);
    res.fold((e) {
      onFail(e);
    }, (res) {
      onSuccess(res);
    });
    _loading = false;
    notifyListeners();
    //upload images and send post request
  }

  updateNextStatus3() {
    final stepsDone = _canContinue[0] && _canContinue[1] && _canContinue[2];
    final lastValue = _canContinue[3];
    final newValue = _data['condition'] != null &&
        _data['numRooms'].text.isNotEmpty &&
        _data['numBathrooms'].text.isNotEmpty &&
        _data['floorNumber'].text.isNotEmpty &&
        _data['floors'].text.isNotEmpty &&
        stepsDone;

    logger.d(newValue);
    if (newValue != lastValue) {
      _canContinue[3] = newValue;
    }
    notifyListeners();
  }

  handleFeature(String feature) {
    _data['features'].contains(feature) == true
        ? _data['features'].remove(feature)
        : _data['features'].add(feature);

    notifyListeners();
  }

  void updateSquareFeet(String value) {
    if (value.isNotEmpty) {
      final double squareMeters = double.parse(value);
      final double squareFeet = squareMeters * 10.7639;
      _data['foot2'].text = squareFeet.toStringAsFixed(2);
    } else {
      _data['foot2'].text = '';
    }
    notifyListeners();
  }

  void updateSquareMeters(String value) {
    if (value.isNotEmpty) {
      final double squareFeet = double.parse(value);
      final double squareMeters = squareFeet / 10.7639;
      _data['m2'].text = squareMeters.toStringAsFixed(2);
    } else {
      _data['m2'].text = '';
    }
    notifyListeners();
  }

  @override
  setFields(List<String> keys, List<dynamic> values) {
    for (var key in keys.indexed) {
      _data[key.$2] = values[key.$1];
    }
    updateNextStatus2();
  }

  handleDetails(category) {
    _data['category'] = category;
    if (detailedCategories.contains(category)) {
      addDetails();
    } else {
      removeDetails();
    }
    notifyListeners();
  }

  addDetails() {
    logger.i('length ${steps.length}');
    if (steps.length == 3) {
      steps.add(const DetailsStep());
      _canContinue.add(false);
    }
  }

  removeDetails() {
    logger.i('length ${steps.length}');
    if (steps.length == 4) {
      steps.removeLast();
      _canContinue.removeLast();
      _data['condition'] = null;
      _data['numRooms'] = TextEditingController();
      _data['numBathrooms'] = TextEditingController();
      _data['floors'] = TextEditingController();
      _data['m2'] = TextEditingController();
      _data['foot2'] = TextEditingController();
      _data['features'] = [];
    }
  }

  @override
  setCountry(String name) {
    _data['country'] = name;
    updateNextStatus();
  }

  updateNextStatus2() {
    final stepsDone = _canContinue[0] && _canContinue[1];
    final lastValue = _canContinue[2];
    final validData = _data['type'] != null && _data['type'] == 'Rent'
        ? _data['period'] != null
        : true &&
            _data['category'] != null &&
            _data['price'].text.isNotEmpty &&
            _data['phoneCode'] != null &&
            _data['phoneNumber'].text.isNotEmpty != null &&
            (_data['contactPhone'] || _data['contactWhatsapp']);
    final isLastStep = steps.length == 3;
    final complementaty = isLastStep ? stepsDone : true;
    final newValue = validData && complementaty;

    if (newValue != lastValue) {
      _canContinue[2] = newValue;
    }
    updateNextStatus();
    notifyListeners();
  }

  @override
  updateNextStatus() {
    _canContinue[1] = _data['country'] != null &&
        isFieldNotEmpty('city') &&
        isFieldNotEmpty('description');
    notifyListeners();
  }

  isFieldNotEmpty(String field) => _data[field].text.isNotEmpty;

  deleteImageAtIndex(int index) {
    _data['media'].removeAt(index);
    _canContinue[0] = _data['media'].isNotEmpty;
    logger.i(_canContinue);
    notifyListeners();
  }

  pickImages({required Function(List<XFile>) onPicked}) async {
    final imagePicker = ImagePicker();
    final pickedImages = await imagePicker.pickMultiImage();
    onPicked(pickedImages);
  }

  addFile(XFile file) {
    _data['media'].add(file);
  }

  notify() {
    _canContinue[0] = _data['media'].isNotEmpty;
    notifyListeners();
  }

  @override
  updateNextStatus1() {
    //todo delete
    throw UnimplementedError();
  }
}
