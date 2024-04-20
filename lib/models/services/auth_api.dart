import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/constants.dart';

class AuthApi {
  final _storage = const FlutterSecureStorage();
  Future<dynamic> getAuth() async {
    final endpoint = '$baseWebsiteUrl/auth';
    final cookie = await _storage.read(key: 'session_cookie');
    logger.i(cookie);
    final res = await Dio().post(
      endpoint,
      options: Options(
        headers: {'Cookie': 'session=$cookie'},
      ),
    );
    return res.data;
  }

  //todo add login
  Future<dynamic> login(String token) async {
    final endpoint = "$baseWebsiteUrl/sign";
    final options = BaseOptions(headers: {'Authorization': 'Bearer $token'});
    final res = await Dio(options).post(endpoint);
    //todo get session cookie
    final cookieValue = res.headers['set-cookie']?[0].split('=')[1];
    if (cookieValue == null) {
      throw Exception('Error retrieving cookie');
    }
    _storage.write(key: 'session_cookie', value: cookieValue);
    return res.data;
  }
}
