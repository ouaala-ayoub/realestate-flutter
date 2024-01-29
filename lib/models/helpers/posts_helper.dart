import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/helpers/static_data_helper.dart';
import 'package:realestate/models/services/posts_api.dart';

import '../core/post/post.dart';
import '../core/search_params.dart';

class PostsHelper {
  var urlsList = [];
  final _api = PostsApi();
  final _staticDataHelper = StaticDataHelper();
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

  Future<Either<dynamic, dynamic>> _addPost(Map<String, dynamic> post) async {
    try {
      final res = await _api.addPost(post);
      return Right(res);
    } on DioException catch (e) {
      return Left(e.response?.data['message']);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, dynamic>> updatePost(Map<String, dynamic> post) async {
    try {
      final res = await _api.updatePost(post);
      return Right(res);
    } on DioException catch (e) {
      return Left(e.response?.data['message']);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, dynamic>> postAdvert(
      Map<String, dynamic> data, String ownerId) async {
    late final Either<dynamic, List<dynamic>> urls;
    if (urlsList.isEmpty) {
      urls = await _staticDataHelper.uploadImages(data['media']);
    } else {
      urls = Right(urlsList);
    }
    // final urls = Right([
    //   'https://firebasestorage.googleapis.com/v0/b/realestate-d9b12.appspot.com/o/posts%2F1705571425323.291bf6c872c3.png?alt=media&token=9170f6d9-7a3f-44a0-98f0-e788367b1e3e'
    // ]);
    logger.i('images uploaded $urls');
    return urls.fold((l) {
      return const Left('Error Uploading Images');
    }, (urls) async {
      logger.i(urls);
      urlsList = urls;
      final body = {
        'description': data['description'].text,
        'media': urls,
        'category': data['category'],
        'price': data['price'].text,
        'location': {
          'country': data['country'],
          'city': data['city'].text,
          'area': data['area'].text
        },
        'owner': ownerId,
        'type': data['type'],
        'period': data['period'],
        'features': data['features'],
        'condition': data['condition'],
        'rooms': data['numRooms'].text,
        'bathrooms': data['numBathrooms'].text,
        'floors': data['floors'].text,
        'floorNumber': data['floorNumber'].text,
        'space': data['m2'].text,
        'contact': {
          'code': data['phoneCode'],
          'phone': data['phoneNumber'].text,
          'type': data['contactPhone'] && data['contactWhatsapp']
              ? 'Both'
              : data['contactPhone']
                  ? 'Call'
                  : 'Whatsapp',
        },
      }..removeWhere((key, value) => value == null || value.isEmpty);
      logger.d('body $body');
      final res = await _addPost(body);
      return res;
    });
  }

  Future<int> getPostsCount(Map<String, dynamic> params) async {
    final res = await _api.getPostsCount(params);
    return res;
  }
}
