import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:realestate/main.dart';

class StaticDataApi {
  Future<Either<dynamic, List<dynamic>>> getCountries() async {
    try {
      const endpoint = 'https://realestatefy.vercel.app/api/countries';
      final res = await Dio().get(endpoint);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, List<dynamic>>> getCategories() async {
    try {
      const endpoint = 'https://realestatefy.vercel.app/api/posts/categories';
      final res = await Dio().get(endpoint);
      logger.d(res.data);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, dynamic>> getNews() async {
    try {
      const endpoint = 'https://realestatefy.vercel.app/api/news';
      final res = await Dio().get(endpoint);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }
}
