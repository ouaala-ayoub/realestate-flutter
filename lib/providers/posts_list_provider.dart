import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/helpers/posts_helper.dart';

import '../models/core/post/post.dart';

class PostsListProvider extends ChangeNotifier {
  final _helper = PostsHelper();
  bool loading = false;
  Either<dynamic, List<Post>> posts = const Right([Post(), Post()]);

  fetshUserPosts(userId) async {
    loading = true;
    posts = await _helper.fetshUserPosts(userId);
    loading = false;
    notifyListeners();
  }

  deletePost(postId, {onSuccess, onFail}) async {
    final res = await _helper.deletePost(postId);
    res.fold((l) => onFail(l), (res) {
      onSuccess(res);
      posts.fold((l) => null, (posts) {
        posts.removeWhere((element) => element == postId);
        notifyListeners();
      });
    });
  }
}
