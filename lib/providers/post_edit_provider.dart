import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/models/helpers/posts_helper.dart';

import '../models/core/post/post.dart';

class PostEditProvider extends ChangeNotifier {
  final _helper = PostsHelper();
  Either<dynamic, Post> post = Right(Post());
  late Map<String, dynamic> postBuilder;
  late String type;
  bool loading = true;
  bool firstTime = true;

  setPostBuilderField(String field, dynamic value) {
    try {
      postBuilder[field] = value;
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
  }

  handleContactType(key, value) {
    postBuilder[key] = value;
    postBuilder['contact']['type'] =
        postBuilder['whatsapp'] && postBuilder['call']
            ? 'Both'
            : postBuilder['whatsapp']
                ? 'Whatsapp'
                : postBuilder['call']
                    ? 'Call'
                    : null;
    notifyListeners();
  }

  fetshPost(String postId) async {
    logger.i(postId);
    loading = true;
    post = await _helper.festhPost(postId);
    loading = false;
    notifyListeners();
  }

  void setType(String type) {
    type = type;
    notifyListeners();
  }

  void initialiseBuilder({String? countryFlag}) {
    postBuilder.remove('owner');
    postBuilder.remove('rejectReasons');
    postBuilder['price'] =
        TextEditingController(text: postBuilder['price'].toString());
    postBuilder['whatsapp'] = postBuilder['contact']['type'] == 'Both' ||
        postBuilder['contact']['type'] == 'Whatsapp';
    postBuilder['call'] = postBuilder['contact']['type'] == 'Both' ||
        postBuilder['contact']['type'] == 'Call';
    postBuilder['contact']['phone'] =
        TextEditingController(text: postBuilder['contact']['phone']);

    postBuilder['phoneFlag'] = countryFlag;
    postBuilder['location']['city'] =
        TextEditingController(text: postBuilder['location']['city']);
    postBuilder['location']['area'] =
        TextEditingController(text: postBuilder['location']['area']);
    postBuilder['description'] =
        TextEditingController(text: postBuilder['description']);

    if (detailedCategories.contains(postBuilder['category'])) {
      postBuilder['rooms'] =
          TextEditingController(text: postBuilder['rooms'].toString());
      postBuilder['bathrooms'] =
          TextEditingController(text: postBuilder['bathrooms'].toString());
      postBuilder['floorNumber'] =
          TextEditingController(text: postBuilder['floorNumber'].toString());
      postBuilder['floors'] =
          TextEditingController(text: postBuilder['floors'].toString());
      postBuilder['space'] =
          TextEditingController(text: postBuilder['space'].toString());
      postBuilder['foot2'] = TextEditingController(
          text:
              squareMetersToSquareFeet(double.parse(postBuilder['space'].text))
                  .toString());
    } else {}
  }

  handleFeature(String feature) {
    postBuilder['features'].contains(feature) == true
        ? postBuilder['features'].remove(feature)
        : postBuilder['features'].add(feature);

    notifyListeners();
  }

  void updateSquareFeet(String value) {
    if (value.isNotEmpty) {
      final double squareMeters = double.parse(value);
      final double squareFeet = squareMeters * 10.7639;
      postBuilder['foot2'].text = squareFeet.toStringAsFixed(2);
    } else {
      postBuilder['foot2'].text = '';
    }
    notifyListeners();
  }

  void updateSquareMeters(String value) {
    if (value.isNotEmpty) {
      final double squareFeet = double.parse(value);
      final double squareMeters = squareFeet / 10.7639;
      postBuilder['space'].text = squareMeters.toStringAsFixed(2);
    } else {
      postBuilder['space'].text = '';
    }
    notifyListeners();
  }

  void notifty() {
    notifyListeners();
  }

  void submitUpdate(
      {required Function() onSuccess,
      required Function(dynamic) onFail}) async {
    //the problem is that the numeric values are inside the map that's stored inside a map
    //solved

    final body = postBuilder.map((key, value) => value is TextEditingController
        ? MapEntry(key, value.text)
        : value is Map
            ? MapEntry(
                key,
                value.map((keyInside, valueInside) => MapEntry(
                    keyInside,
                    valueInside is TextEditingController
                        ? valueInside.text
                        : valueInside)))
            : MapEntry(key, value))
      ..removeWhere((key, value) => value == null)
      ..remove('phoneFlag')
      ..remove('whatsapp')
      ..remove('call')
      ..remove('foot2');

    loading = true;
    notifyListeners();
    final res = await _helper.updatePost(body);
    res.fold((e) => onFail(e), (r) => onSuccess());
    loading = false;
    notifyListeners();
  }

  bool canUpdate(Map<String, dynamic> postBuilder) {
    bool validData = true;
    postBuilder.forEach((key, value) {
      if (key == 'period') {
        validData = validData &&
            (postBuilder['type'] == 'Rent'
                ? postBuilder['period'] != null
                : true);
        return;
      }
      if (key == 'area') {
        return;
      }
      validData = validData &&
          value != null &&
          (value is TextEditingController
              ? value.text.isNotEmpty
              : value is String || value is int || value is bool
                  ? value.toString().isNotEmpty
                  : value is List
                      ? true
                      : canUpdate(value));
    });
    return validData;
  }
}
