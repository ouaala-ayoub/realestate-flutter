import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/liked_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/error_widget.dart';
import 'package:realestate/views/post_widget.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Liked Posts')),
      child: Consumer<RealestateAuthProvider>(
          builder: (context, provider, widget) => provider.auth == null
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : provider.auth!.fold((error) {
                  if (error == 'Unauthorized') {
                    return const LoginPage(
                      goType: GoType.doNothing,
                      sourceRoute: '/',
                    );
                  } else {
                    return ErrorScreen(
                      message: 'Unexpected error',
                      refreshFunction: () => provider.fetshAuth(),
                    );
                  }
                },
                  (user) => Consumer<LikedPageProvider>(
                          builder: (context, likedProvider, _) {
                        if (likedProvider.firstTime) {
                          likedProvider.fetshLikedPosts(user.id);
                          likedProvider.firstTime = false;
                        }
                        return likedProvider.loading
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : likedProvider.likedPosts.fold(
                                (e) => ErrorScreen(
                                    refreshFunction: () =>
                                        likedProvider.fetshLikedPosts(user.id),
                                    message: e.toString()), (liked) {
                                return liked.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No liked posts',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: liked.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item = liked[index];
                                          final country = context
                                              .read<SearchProvider>()
                                              .countries
                                              .fold((l) => null, (r) {
                                            try {
                                              return r.firstWhere((element) =>
                                                  element.name ==
                                                  item.location?.country);
                                            } catch (e) {
                                              logger.e('element not found');
                                              return null;
                                            }
                                          });
                                          return PostCard(
                                              onHeartClicked: (postId) {
                                                provider.unlike(postId,
                                                    onSuccess: () {
                                                  provider.notify();
                                                  provider.fetshAuth();
                                                  likedProvider
                                                      .fetshLikedPosts(user.id);
                                                });
                                              },
                                              countryInfo: country,
                                              type: UseType.liked,
                                              post: item,
                                              onClicked: () => context.push(
                                                  '/postPage',
                                                  extra: item));
                                        },
                                      );
                              });
                      }))),
    );
  }
}
