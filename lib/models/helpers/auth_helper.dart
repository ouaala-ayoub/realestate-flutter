import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/post/owner.dart';
import 'package:realestate/models/services/auth_api.dart';

class AuthHelper {
  final _api = AuthApi();

  Future<Either<dynamic, RealestateUser>> fetshAuth() async {
    try {
      return Right(RealestateUser(id: '121212'));
      final res = await _api.getAuth();
      return Right(RealestateUser.fromMap(res));
    } on DioException catch (e) {
      logger.e(e.response);
      return Left(e.response?.data['message']);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, RealestateUser>> login(String token) async {
    try {
      final res = await _api.login(token);
      return Right(RealestateUser.fromMap(res));
    } catch (e) {
      return Left(e);
    }
  }
}
