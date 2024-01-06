import 'package:dio/dio.dart';

class UsersApi {
  Future<dynamic> fetshUserById(String id) async {
    final endpoint = 'https://realestatefy.vercel.app/api/users/$id';
    final res = await Dio().get(endpoint);
    return res.data;
  }
}
