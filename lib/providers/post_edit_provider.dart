import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/helpers/posts_helper.dart';

import '../models/core/post/post.dart';

class PostEditProvider extends ChangeNotifier {
  final _helper = PostsHelper();
  Either<dynamic, Post> post = const Right(Post());
  late Map<String, dynamic> postBuilder;
  late String type;
  bool loading = true;
  bool firstTime = true;

  setPostBuilderField(String field, dynamic value) {
    try {
      logger.i('before ${postBuilder[field]}');
      postBuilder[field] = value;
      logger.i('after ${postBuilder[field]}');
      notifyListeners();
    } catch (e) {
      logger.e(e);
    }
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
}
