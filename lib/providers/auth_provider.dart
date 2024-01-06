import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/post/owner.dart';
import 'package:realestate/models/helpers/auth_helper.dart';

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

  //todo continue
  login(token,
      {required Function(RealestateUser) onSuccess,
      required Function(dynamic) onFail}) async {
    final res = await _helper.login(token);
    res.fold((l) => onFail(l), (r) => onSuccess(r));
  }
}
