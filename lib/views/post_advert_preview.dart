// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'helper_widgets/error_widget.dart';
import 'login_page.dart';
import 'helper_widgets/route_button.dart';

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
              : authProvider.auth!.fold(
                  (error) {
                    if (error == 'Unauthorized') {
                      return const LoginPage(
                        goType: GoType.doNothing,
                        sourceRoute: '/',
                      );
                    } else {
                      return ErrorScreen(
                          refreshFunction: () => authProvider.fetshLateAuth(),
                          message: 'Unexpected error');
                    }
                  },
                  (auth) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.add_circled),
                            Text(
                              'Post Advert',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RouteButton(
                          text: 'Rent / Forsale',
                          route: '/post_advert/${auth.id}',
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Center(
                          child: Text(
                            'Or',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RouteButton(
                          text: 'Looking for a Realestate?',
                          route: '/looking_for_advert/${auth.id}',
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
