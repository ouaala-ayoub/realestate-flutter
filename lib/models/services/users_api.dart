import 'package:dio/dio.dart';
import 'package:realestate/models/core/constants.dart';

class UsersApi {
  Future<dynamic> fetshUserById(String id) async {
    final endpoint = '$baseWebsiteUrl/users/$id';
    final res = await Dio().get(endpoint);
    return res.data;
  }
}
