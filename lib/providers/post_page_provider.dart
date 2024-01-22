import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/post/owner.dart';
import 'package:realestate/models/core/post/post.dart';
import 'package:realestate/models/helpers/users_helper.dart';

import '../models/helpers/posts_helper.dart';

class PostPageProvider extends ChangeNotifier {
  PostPageProvider(Post initPost) : post = Right(initPost);
  static final _helper = UsersHelper();
  static final _postHelper = PostsHelper();
  bool loading = false;
  bool firstTime = true;
  Either<dynamic, RealestateUser>? user;
  Either<dynamic, Post> post;

  fetshUser(String id) async {
    loading = true;
    final res = await _helper.getUserById(id);
    user = res;
    loading = false;
    notifyListeners();
  }

  fetshPost(String postId) async {
    // loading = true;
    post = await _postHelper.festhPost(postId);
    notifyListeners();
  }
}
