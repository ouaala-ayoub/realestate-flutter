import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realestate/main.dart';

class AuthApi {
  final _storage = const FlutterSecureStorage();
  Future<dynamic> getAuth() async {
    const endpoint = 'https://realestatefy.vercel.app/api/auth';
    final cookie = await _storage.read(key: 'session_cookie');
    final res = await Dio()
        .post(endpoint, options: Options(headers: {'session': cookie}));
    return res.data;
  }

  //todo add login
  Future<dynamic> login(String token) async {
    const endpoint = "https://realestatefy.vercel.app/api/login";
    final options = BaseOptions(headers: {'Authorization': 'Bearer $token'});
    final res = await Dio(options).post(endpoint);
    return res.data;
  }
}
