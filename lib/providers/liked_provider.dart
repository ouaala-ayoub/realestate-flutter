import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/helpers/posts_helper.dart';

import '../main.dart';
import '../models/core/post/post.dart';

class LikedPageProvider extends ChangeNotifier {
  final _helper = PostsHelper();
  bool firstTime = true;
  bool loading = true;
  Either<dynamic, List<Post>> likedPosts = const Right([]);

  fetshLikedPosts(userId) async {
    loading = true;
    likedPosts = await _helper.fetshLikedPosts(userId);
    logger.d(likedPosts);
    loading = false;
    notifyListeners();
  }
}
