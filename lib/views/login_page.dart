import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  final String sourceRoute;
  const LoginPage({required this.sourceRoute, super.key});

  //! context.go maybe after success google login
  @override
  Widget build(BuildContext context) {
    return Consumer<RealestateAuthProvider>(
      builder: (context, provider, widget) => SignInScreen(
        actions: [
          AuthStateChangeAction((context, state) async {
            if (state is SignedIn) {
              logger.i('logged in');
              final token = await state.user?.getIdToken();
              logger.i('logged token $token');
              //! test is login is successfull with our backend if i change id
              provider.login(token,
                  onSuccess: (user) => context.go(sourceRoute),
                  onFail: (e) => logger.e(e));
              // context.go(sourceRoute);
              FirebaseAuth.instance.signOut();
            }
          })
        ],
        showAuthActionSwitch: false,
      ),
    );
  }
}
