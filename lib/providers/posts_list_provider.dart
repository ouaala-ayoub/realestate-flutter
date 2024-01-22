import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/helpers/posts_helper.dart';

import '../models/core/post/post.dart';

class PostsListProvider extends ChangeNotifier {
  final _helper = PostsHelper();
  bool loading = false;
  late Either<dynamic, List<Post>> posts;
  late Either<dynamic, List<Post>> _filtred;
  Either<dynamic, List<Post>> get filtred => _filtred;

  //todo add search

  fetshUserPosts(userId) async {
    loading = true;
    posts = await _helper.fetshUserPosts(userId);
    _filtred = posts;
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

  runFilter(String query) {
    if (query.isEmpty) {
      _filtred = posts;
    } else {
      _filtred = posts.fold((l) => Left(l), (r) {
        return Right(r
            .where((element) =>
                element
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ==
                true)
            .toList());
      });
    }
    notifyListeners();
  }
}
