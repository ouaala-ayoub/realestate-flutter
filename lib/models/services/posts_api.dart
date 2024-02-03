import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/core/search_params.dart';

class PostsApi {
  Future<Either<dynamic, List<dynamic>>> fetshPosts(
      {SearchParams? searchParams}) async {
    try {
      final params = searchParams?.toMap();
      const endpoint = '$baseWebsiteUrl/posts';
      final res = await Dio().get(endpoint, queryParameters: params);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<List<dynamic>> fetshUserLiked(String userId) async {
    final endpoint = '$baseWebsiteUrl/users/$userId/likes';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  Future<List<dynamic>> fetshUserPosts(String userId) async {
    final endpoint = '$baseWebsiteUrl/users/$userId/posts';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  Future<String> unlike(String postId) async {
    final endpoint = '$baseWebsiteUrl/posts/$postId/unlike';
    final options = await retrieveCookieOptions();
    final res = await Dio(options).patch(endpoint);
    return res.data['message'];
  }

  Future<String> like(String postId) async {
    final endpoint = '$baseWebsiteUrl/posts/$postId/like';
    final options = await retrieveCookieOptions();
    final res = await Dio(options).patch(endpoint);
    return res.data['message'];
  }

  Future<dynamic> deletePost(postId) async {
    final endpoint = '$baseWebsiteUrl/posts/$postId';
    final options = await retrieveCookieOptions();
    final res = await Dio(options).delete(endpoint);
    return res.data;
  }

  Future<dynamic> fetshPost(String postId) async {
    final endpoint = '$baseWebsiteUrl/posts/$postId';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  Future<dynamic> addPost(Map<String, dynamic> post) async {
    const endpoint = '$baseWebsiteUrl/posts';
    final options = await retrieveCookieOptions();
    final res = await Dio(options).post(endpoint, data: jsonEncode(post));
    return res.data;
  }

  Future<dynamic> updatePost(Map<String, dynamic> post) async {
    final endpoint = '$baseWebsiteUrl/posts/${post['_id']}';
    final options = await retrieveCookieOptions();
    final res = await Dio(options).put(endpoint, data: jsonEncode(post));
    return res.data;
  }

  Future<int> getPostsCount(Map<String, dynamic> params) async {
    params['status'] = 'Approved';
    const endpoint = '$baseWebsiteUrl/posts/count';
    final res = await Dio().get(endpoint, queryParameters: params);
    return res.data;
  }
}

Future<BaseOptions> retrieveCookieOptions() async {
  final cookie = await const FlutterSecureStorage().read(key: 'session_cookie');
  final options = BaseOptions(headers: {'Cookie': 'session=$cookie'});
  return options;
}
