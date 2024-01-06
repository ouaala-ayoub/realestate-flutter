import 'package:dartz/dartz.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/services/posts_api.dart';

import '../core/post/post.dart';
import '../core/search_params.dart';

class PostsHelper {
  final _api = PostsApi();
  Future<Either<dynamic, List<Post>>> fetshPosts(
      {String? search,
      String? country,
      String? city,
      String? category,
      String? type,
      String? n,
      String? condition,
      int page = 1,
      List<String>? features}) async {
    try {
      final searchParams = SearchParams(
          search: search,
          country: country,
          city: city,
          category: category,
          type: type,
          n: n,
          condition: condition,
          page: page,
          features: features);
      final res = await _api.fetshPosts(searchParams: searchParams);
      logger.i('getPosts response $res');
      return res.fold(
          (l) => Left(l),
          (r) => Right(
              r.map((map) => Post.fromMap(map, withOwner: false)).toList()));
    } catch (e) {
      logger.e(e);
      return Left(e);
    }
  }
}
