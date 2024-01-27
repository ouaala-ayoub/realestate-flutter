import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/models/helpers/posts_helper.dart';
import 'package:realestate/views/post_advert_steps/details_step.dart';
import '../main.dart';
import '../views/post_advert_steps/post_advert_step1.dart';
import '../views/post_advert_steps/post_advert_step2.dart';
import '../views/post_advert_steps/post_advert_step3.dart';

class PostAdvertProvider extends ChangeNotifier {
  bool loading = false;
  static final _helper = PostsHelper();
  List<bool> canContinue = [false, false, false];
  final steps = [
    const PostAdvertImagesStep(),
    const LocationDataStep(),
    const PropretyInfoStep(),
  ];
  final Map<String, dynamic> data = {
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
  // final Map<String, String?> error = {'country': null};

  void submitPost(
      {required String ownerId,
      Function(dynamic)? onStart,
      required Function(dynamic) onSuccess,
      required Function(dynamic) onFail}) async {
    loading = true;
    notifyListeners();
    final res = await _helper.postAdvert(data, ownerId);
    res.fold((e) {
      onFail(e);
    }, (res) {
      onSuccess(res);
    });
    loading = false;
    notifyListeners();
    //upload images and send post request
  }

  updateNextStatus3() {
    final stepsDone = canContinue[0] && canContinue[1] && canContinue[2];
    final lastValue = canContinue[3];
    final newValue = data['condition'] != null &&
        data['numRooms'].text.isNotEmpty &&
        data['numBathrooms'].text.isNotEmpty &&
        data['floorNumber'].text.isNotEmpty &&
        data['floors'].text.isNotEmpty &&
        stepsDone;

    logger.d(newValue);
    if (newValue != lastValue) {
      canContinue[3] = newValue;
    }
    notifyListeners();
  }

  handleFeature(String feature) {
    data['features'].contains(feature) == true
        ? data['features'].remove(feature)
        : data['features'].add(feature);

    notifyListeners();
  }

  void updateSquareFeet(String value) {
    if (value.isNotEmpty) {
      final double squareMeters = double.parse(value);
      final double squareFeet = squareMeters * 10.7639;
      data['foot2'].text = squareFeet.toStringAsFixed(2);
    } else {
      data['foot2'].text = '';
    }
    notifyListeners();
  }

  void updateSquareMeters(String value) {
    if (value.isNotEmpty) {
      final double squareFeet = double.parse(value);
      final double squareMeters = squareFeet / 10.7639;
      data['m2'].text = squareMeters.toStringAsFixed(2);
    } else {
      data['m2'].text = '';
    }
    notifyListeners();
  }

  setFields(List<String> keys, List<dynamic> values) {
    for (var key in keys.indexed) {
      data[key.$2] = values[key.$1];
    }
    notifyListeners();
    updateNextStatus2();
  }

  handleDetails(category) {
    data['category'] = category;
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
      canContinue.add(false);
    }
  }

  removeDetails() {
    logger.i('length ${steps.length}');
    if (steps.length == 4) {
      steps.removeLast();
      canContinue.removeLast();
      data['condition'] = null;
      data['numRooms'] = TextEditingController();
      data['numBathrooms'] = TextEditingController();
      data['floors'] = TextEditingController();
      data['m2'] = TextEditingController();
      data['foot2'] = TextEditingController();
      data['features'] = [];
    }
  }

  setCountry(String country) {
    data['country'] = country;
    updateNextStatus();
  }

  updateNextStatus2() {
    final stepsDone = canContinue[0] && canContinue[1];
    final lastValue = canContinue[2];
    final validData = data['type'] != null && data['type'] == 'Rent'
        ? data['period'] != null
        : true &&
            data['category'] != null &&
            data['price'].text.isNotEmpty &&
            data['phoneCode'] != null &&
            data['phoneFlag'] != null &&
            data['phoneNumber'].text.isNotEmpty != null &&
            (data['contactPhone'] || data['contactWhatsapp']);
    final isLastStep = steps.length == 3;
    final complementaty = isLastStep ? stepsDone : true;
    final newValue = validData && complementaty;

    if (newValue != lastValue) {
      canContinue[2] = newValue;
    }
    notifyListeners();
  }

  updateNextStatus() {
    canContinue[1] = data['country'] != null &&
        isFieldNotEmpty('city') &&
        isFieldNotEmpty('description');
    notifyListeners();
  }

  isFieldNotEmpty(String field) => data[field].text.isNotEmpty;

  deleteImageAtIndex(int index) {
    data['media'].removeAt(index);
    canContinue[0] = data['media'].isNotEmpty;
    notifyListeners();
  }

  pickImages({required Function(List<XFile>) onPicked}) async {
    final imagePicker = ImagePicker();
    final pickedImages = await imagePicker.pickMultiImage();
    onPicked(pickedImages);
  }

  addFile(XFile file) {
    data['media'].add(file);
  }

  notify() {
    canContinue[0] = data['media'].isNotEmpty;
    notifyListeners();
  }
}
