import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/auth_provider.dart';
import 'package:realestate/views/login_page.dart';

import '../main.dart';
import '../models/core/post/owner.dart';
import 'error_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
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
                        logger.e('Unauthorized');
                        return const LoginPage(
                          sourceRoute: '/settings',
                        );
                      } else {
                        return ErrorScreen(
                          message: error.toString(),
                          refreshFunction: () => authProvider.fetshAuth(),
                        );
                      }
                    },
                      (user) => SafeArea(
                            child: SettingsBody(
                              user: user,
                            ),
                          )),
        ));
  }
}

class SettingsBody extends StatelessWidget {
  final RealestateUser user;
  final profile = FirebaseAuth.instance.currentUser?.photoURL;

  SettingsBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            Image.network(
              profile.toString(),
              errorBuilder: (context, obj, trace) => Container(
                decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemYellow)),
                height: 120,
                width: 120,
                child: const Icon(
                  CupertinoIcons.eye_slash_fill,
                ),
              ), // Replace with your image path
              height: 120.0, // Adjust the height as needed
              fit: BoxFit.fitWidth,
            ),
            // CupertinoUserInterfaceLevel(
            //   data: CupertinoUserInterfaceLevelData.elevated,
            //   child: Container(
            //     width: 100,
            //     height: 100,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.rectangle,
            //       image: DecorationImage(
            //           fit: BoxFit.cover, image: NetworkImage(profile!)),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),
            Text(
              user.name != null ? user.name! : 'unavailable',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email != null ? user.email! : 'unavailable',
              style: const TextStyle(
                fontSize: 18,
                color: CupertinoColors.inactiveGray,
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () {
                context.push('/profile/${user.id}');
              },
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(CupertinoIcons.person_crop_circle_fill_badge_exclam),
                SizedBox(
                  width: 10,
                ),
                Text('Edit Profile')
              ]),
            ),
            CupertinoButton(
              onPressed: () => context.push('/post_advert'),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(CupertinoIcons.add_circled),
                SizedBox(
                  width: 10,
                ),
                Text('Post Advert')
              ]),
            ),
            CupertinoButton(
              onPressed: () {
                final provider = context.read<RealestateAuthProvider>();
                FirebaseAuth.instance.signOut();
                provider.logout();
                provider.fetshAuth();
              },
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(CupertinoIcons.arrow_left_circle),
                SizedBox(
                  width: 10,
                ),
                Text('Logout')
              ]),
            ),
          ],
        )
      ],
    );
  }
}
