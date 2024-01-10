import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/providers/posts_list_provider.dart';
import 'package:realestate/views/error_widget.dart';
import 'package:realestate/views/post_edit_widget.dart';
import 'package:realestate/views/post_widget.dart';

import '../providers/search_provider.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({required this.userId, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    logger.d(widget.userId);
    context.read<PostsListProvider>().fetshUserPosts(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Profile')),
      child: Consumer<PostsListProvider>(
          builder: (context, provider, _) => SafeArea(
                child: provider.loading
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : provider.posts.fold(
                        (e) => ErrorScreen(
                            refreshFunction: () =>
                                provider.fetshUserPosts(widget.userId),
                            message: 'Unexpected error'),
                        (posts) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(children: [
                                const SizedBox(height: 12),
                                const CupertinoSearchTextField(),
                                const SizedBox(height: 12),
                                posts.isEmpty
                                    ? const Expanded(
                                        child: Center(
                                        child: Text(
                                          'No posts Yet',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ))
                                    : Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: posts.length,
                                            itemBuilder: (context, index) {
                                              final post = posts[index];
                                              final country = context
                                                  .read<SearchProvider>()
                                                  .countries
                                                  .fold((l) => null, (r) {
                                                try {
                                                  return r.firstWhere(
                                                      (element) =>
                                                          element.name ==
                                                          post.location
                                                              ?.country);
                                                } catch (e) {
                                                  logger.e('element not found');
                                                  return null;
                                                }
                                              });
                                              return PostEditWidget(
                                                  onLongPressed: () {
                                                    showOptionsPopUp(context,
                                                        provider, post.id!);
                                                  },
                                                  type: UseType.edit,
                                                  post: post,
                                                  countryInfo: country,
                                                  onClicked: () => context.push(
                                                      '/post_edit/${post.id}'));
                                            }),
                                      )
                              ]),
                            )),
              )),
    );
  }

  Future<dynamic> showOptionsPopUp(
      BuildContext context, PostsListProvider provider, String postId) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: [
                // CupertinoActionSheetAction(
                //     onPressed: () {
                //       //todo write this function
                //       context.pop();
                //     },
                //     child: const Text('Set Out Of Order',
                //         style: TextStyle(color: CupertinoColors.white))),
                CupertinoActionSheetAction(
                    onPressed: () => showDeleteDialog((context) {
                          provider.deletePost(postId, onSuccess: (message) {
                            logger.i('message $message');
                            context.pop();
                            context.pop();
                          }, onFail: (e) {
                            // logger.e(e);
                            context.pop();
                            context.pop();
                          });
                        }),
                    isDestructiveAction: true,
                    child: const Text('Delete This Post')),
                CupertinoActionSheetAction(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: CupertinoColors.white),
                    ))
              ],
            ));
  }

  showDeleteDialog(Function(BuildContext) deleteFunction) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text(
                'Deleting !',
                style: TextStyle(fontSize: 18),
              ),
              content: const Text(
                'Are you sure you want to delete this post ?',
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    //todo write the delete function
                    deleteFunction(context);
                  },
                  child: const Text('Yes'),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                )
              ],
            ));
  }
}
