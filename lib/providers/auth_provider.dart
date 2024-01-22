import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realestate/models/core/post/owner.dart';
import 'package:realestate/models/helpers/auth_helper.dart';
import 'package:realestate/models/helpers/posts_helper.dart';

import '../main.dart';

class RealestateAuthProvider extends ChangeNotifier {
  final _helper = AuthHelper();
  bool loading = true;
  Either<dynamic, RealestateUser>? _auth;
  Either<dynamic, RealestateUser>? get auth => _auth;
  Either<dynamic, RealestateUser>? _loginRes;
  Either<dynamic, RealestateUser>? get loginRes => _loginRes;
  fetshAuth() async {
    loading = true;
    _auth = await _helper.fetshAuth();
    loading = false;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  //todo continue
  login(token,
      {required Function(RealestateUser) onSuccess,
      required Function(dynamic) onFail}) async {
    final res = await _helper.login(token);
    res.fold((l) => onFail(l), (r) => onSuccess(r));
  }

  unlike(postId, {required Function() onSuccess}) async {
    final res = await PostsHelper().unlike(postId);
    res.fold((l) => null, (response) {
      logger.i(response);
      onSuccess();
    });
  }

  void like(postId, {required Function() onSuccess}) async {
    final res = await PostsHelper().like(postId);
    res.fold((l) => null, (response) {
      logger.i(response);
      onSuccess();
    });
  }

  logout() async {
    await const FlutterSecureStorage().delete(key: 'session_cookie');
  }
}
