import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/auth_provider.dart';
import 'package:realestate/views/login_page.dart';

import 'error_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Settings')),
        child: Consumer<RealestateAuthProvider>(
          builder: (consumerContext, authProvider, consumerWidget) =>
              authProvider.loading || authProvider.auth == null
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : authProvider.auth!.fold((error) {
                      //todo check error type or text or smtg
                      //todo return screen based on that(login or error)
                      if (error == 'Unauthorized') {
                        return const LoginPage(
                          sourceRoute: '/settings',
                        );
                      } else {
                        return ErrorScreen(
                          message: error.toString(),
                          refreshFunction: () => authProvider.fetshAuth(),
                        );
                      }
                    }, (user) => Center(child: Text('user ${user.id}'))),
        ));
  }
}
