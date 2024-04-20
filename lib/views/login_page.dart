import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/auth_provider.dart';

enum GoType { pushReplaced, push, go, doNothing }

class LoginPage extends StatelessWidget {
  final GoType goType;
  final String sourceRoute;
  const LoginPage({required this.goType, required this.sourceRoute, super.key});

  //! context.go maybe after success google login
  @override
  Widget build(BuildContext context) {
    showUserDataPolicy() async {
      final res = await showCupertinoDialog<bool?>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Privacy policy'),
          content: Column(
            children: [
              const Text(
                'i have read realestate.country privacy policy and i accept them',
                style: TextStyle(fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  //todo open url
                  launchWebSite('${dotenv.env['WEBSITE_URL']}policy');
                },
                child: const Text(
                  'realestate.country privacy policy',
                  style: TextStyle(
                    color: CupertinoColors.systemYellow,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              textStyle: const TextStyle(color: CupertinoColors.white),
              child: const Text('Yes'),
              onPressed: () => context.pop(true),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('No'),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
      return res;
    }

    return Consumer<RealestateAuthProvider>(
      builder: (context, provider, widget) => SignInScreen(
        footerBuilder: (context, AuthAction action) => Align(
          alignment: Alignment.center,
          child: Text(
            provider.error ?? '',
            style: const TextStyle(
              color: CupertinoColors.systemRed,
            ),
          ),
        ),
        actions: [
          AuthStateChangeAction(
            (context, state) async {
              if (state is SignedIn) {
                final token = await state.user?.getIdToken();
                //! test is login is successfull with our backend if i change id
                final agreed = await showUserDataPolicy();
                if (agreed == true) {
                  provider.login(
                    token,
                    onSuccess: (user) {
                      logger.i(user);
                      provider.fetshAuth();
                      goType == GoType.pushReplaced
                          ? context.pushReplacement(sourceRoute)
                          : goType == GoType.push
                              ? context.push(sourceRoute)
                              : goType == GoType.go
                                  ? context.go(sourceRoute)
                                  : () {};
                    },
                    onFail: (e) => provider.setError("Login Failed"),
                  );
                }

                // context.go(sourceRoute);
                // FirebaseAuth.instance.signOut();
              }
              if (state is AuthFailed) {
                logger.e(state.exception.toString());
              }
            },
          )
        ],
        showAuthActionSwitch: false,
      ),
    );
  }
}
