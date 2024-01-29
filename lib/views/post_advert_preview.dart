import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'error_widget.dart';
import 'login_page.dart';

class PostAdvertButtonPage extends StatelessWidget {
  const PostAdvertButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Post Advert'),
      ),
      child: SafeArea(
        child: Consumer<RealestateAuthProvider>(
          builder: (context, authProvider, _) => authProvider.loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : authProvider.auth!.fold((error) {
                  if (error == 'Unauthorized') {
                    return const LoginPage(
                      goType: GoType.push,
                      sourceRoute: '/post_advert',
                    );
                  } else {
                    return ErrorScreen(
                        refreshFunction: () => authProvider.fetshLateAuth(),
                        message: 'Unexpected error');
                  }
                },
                  (auth) => Center(
                        child: CupertinoButton.filled(
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.add,
                                    size: 48,
                                  ),
                                  Text('Post Advert')
                                ]),
                            onPressed: () =>
                                context.push('/post_advert/${auth.id}')),
                      )),
        ),
      ),
    );
  }
}
