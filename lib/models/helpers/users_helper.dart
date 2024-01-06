import 'package:dartz/dartz.dart';
import 'package:realestate/models/core/post/owner.dart';
import 'package:realestate/models/services/users_api.dart';

class UsersHelper {
  static final _api = UsersApi();

  Future<Either<dynamic, RealestateUser>> getUserById(String id) async {
    try {
      final res = await _api.fetshUserById(id);
      return Right(RealestateUser.fromMap(res));
    } catch (e) {
      return Left(e);
    }
  }
}
