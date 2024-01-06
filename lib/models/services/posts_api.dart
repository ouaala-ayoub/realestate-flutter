import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/search_params.dart';

class PostsApi {
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
}
