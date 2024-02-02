import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/post/post.dart';
import 'package:realestate/models/helpers/posts_helper.dart';

import '../main.dart';

class LookingForPostEditProvider extends ChangeNotifier {
  final _helper = PostsHelper();
  Either<dynamic, Post> post = Right(Post());
  late Map<String, dynamic> postBuilder;
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

  void initialiseBuilder({String? countryFlag}) {
    postBuilder.remove('owner');
    postBuilder.remove('rejectReasons');
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
  }

  void notifty() {
    notifyListeners();
  }

  void submitUpdate(
      {required Function() onSuccess,
      required Function(dynamic) onFail}) async {
    final body = {
      '_id': postBuilder['_id'],
      'description': postBuilder['description'].text,
      'location': {
        'country': postBuilder['location']['country'],
        'city': postBuilder['location']['city'].text,
        'area': postBuilder['location']['area'].text,
      },
      'contact': {
        'phone': postBuilder['contact']['phone'].text,
        'code': postBuilder['contact']['code'],
        'type': postBuilder['contact']['type'],
      }
    };

    logger.i('body $body');
    loading = true;
    notifyListeners();
    final res = await _helper.updatePost(body);
    res.fold((e) => onFail(e), (r) => onSuccess());
    loading = false;
    notifyListeners();
  }

  bool canUpdate() {
    bool validData = true;
    postBuilder.forEach((key, value) {
      validData = validData &&
          (value is TextEditingController
              ? value.text.isNotEmpty
              : value is String
                  ? value.isNotEmpty
                  : true);
    });
    logger.i(validData);
    return validData;
  }
}
