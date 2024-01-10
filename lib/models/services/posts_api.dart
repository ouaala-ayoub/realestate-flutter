import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/search_params.dart';

class PostsApi {
  final _storage = const FlutterSecureStorage();
  Future<Either<dynamic, List<dynamic>>> fetshPosts(
      {SearchParams? searchParams}) async {
    try {
      const endpoint = 'https://realestatefy.vercel.app/api/posts';
      logger.i(searchParams?.toMap());
      final res = await Dio().get(
        endpoint,
        queryParameters: searchParams?.toMap(),
      );
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<List<dynamic>> fetshUserLiked(String userId) async {
    final endpoint = 'https://realestatefy.vercel.app/api/users/$userId/likes';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  Future<List<dynamic>> fetshUserPosts(String userId) async {
    final endpoint =
        'https://realestatefy.vercel.app/api/users/64e0fe8b10396bcca2f1c771/posts';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  Future<String> unlike(String postId) async {
    final endpoint = 'https://realestatefy.vercel.app/api/posts/$postId/unlike';
    final options = await _retrieveCookieOptions();
    final res = await Dio(options).patch(endpoint);
    return res.data;
  }

  Future<String> like(String postId) async {
    final endpoint = 'https://realestatefy.vercel.app/api/posts/$postId/like';
    final options = await _retrieveCookieOptions();
    final res = await Dio(options).patch(endpoint);
    return res.data;
  }

  Future<dynamic> deletePost(postId) async {
    final endpoint = 'https://realestatefy.vercel.app/api/posts/$postId';
    final options = await _retrieveCookieOptions();
    final res = await Dio(options).delete(endpoint);
    return res.data;
  }

  Future<BaseOptions> _retrieveCookieOptions() async {
    final cookie = await _storage.read(key: 'session_cookie');
    final options = BaseOptions(headers: {'Cookie': 'session=$cookie'});
    return options;
  }

  Future<dynamic> fetshPost(String postId) async {
    final endpoint = 'https://realestatefy.vercel.app/api/posts/$postId';
    final res = await Dio().get(endpoint);
    return res.data;
  }
}
