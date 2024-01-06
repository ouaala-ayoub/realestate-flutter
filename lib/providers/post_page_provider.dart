import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/post/owner.dart';
import 'package:realestate/models/helpers/users_helper.dart';

class PostPageProvider extends ChangeNotifier {
  final helper = UsersHelper();
  bool loading = false;
  Either<dynamic, RealestateUser>? user;

  fetshUser(String id) async {
    loading = true;
    final res = await helper.getUserById(id);
    user = res;
    loading = false;
    notifyListeners();
  }
}
