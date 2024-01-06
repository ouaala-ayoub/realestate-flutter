import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/views/error_widget.dart';

import '../providers/auth_provider.dart';
import 'login_page.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Liked')),
      child: Consumer<RealestateAuthProvider>(
          builder: (context, provider, widget) =>
              provider.loading || provider.auth == null
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : provider.auth!.fold((error) {
                      if (error == 'Unauthorized') {
                        return const LoginPage(
                          sourceRoute: '/settings',
                        );
                      } else {
                        return ErrorScreen(
                          message: error.toString(),
                          refreshFunction: () => provider.fetshAuth(),
                        );
                      }
                    },
                      (user) => Center(
                            child: Text('${user.id}'),
                          ))),
    );
  }
}
