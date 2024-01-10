import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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

  Future<Either<dynamic, List<Post>>> fetshLikedPosts(String userId) async {
    try {
      final res = await _api.fetshUserLiked(userId);
      return Right(res
          .map((postMap) => Post.fromMap(postMap, withOwner: false))
          .toList());
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, List<Post>>> fetshUserPosts(String userId) async {
    try {
      final res = await _api.fetshUserPosts(userId);
      return Right(res
          .map((postMap) => Post.fromMap(postMap, withOwner: false))
          .toList());
    } catch (e) {
      logger.e(e);
      return Left(e);
    }
  }

  Future<Either<dynamic, String>> like(String postId) async {
    try {
      final res = await _api.like(postId);
      return Right(res);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, String>> unlike(String postId) async {
    try {
      final res = await _api.unlike(postId);
      return Right(res);
    } catch (e) {
      logger.e(e);
      return Left(e);
    }
  }

  Future<Either<dynamic, String>> deletePost(postId) async {
    try {
      final res = await _api.deletePost(postId);
      return Right(res['message']);
    } on DioException catch (e) {
      logger.e(e.response?.data);
      return Left(e);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, Post>> festhPost(String postId) async {
    try {
      final res = await _api.fetshPost(postId);
      return Right(Post.fromMap(res, withOwner: true));
    } catch (e) {
      return Left(e);
    }
  }
}
