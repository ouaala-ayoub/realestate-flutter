import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/constants.dart';

class StaticDataApi {
  Future<Either<dynamic, List<dynamic>>> getCountries() async {
    try {
      final endpoint = '$baseWebsiteUrl/countries';
      final res = await Dio().get(endpoint);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, List<dynamic>>> getCategories() async {
    try {
      final endpoint = '$baseWebsiteUrl/posts/categories';
      final res = await Dio().get(endpoint);
      logger.d(res.data);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, dynamic>> getNews() async {
    try {
      final endpoint = '$baseWebsiteUrl/news';
      final res = await Dio().get(endpoint);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }
}
