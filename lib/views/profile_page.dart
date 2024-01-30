import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/post/post.dart';
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
                    : provider.filtred.fold(
                        (e) => ErrorScreen(
                            refreshFunction: () =>
                                provider.fetshUserPosts(widget.userId),
                            message: 'Unexpected error'),
                        (posts) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(children: [
                                const SizedBox(height: 12),
                                CupertinoSearchTextField(
                                  onChanged: (query) =>
                                      provider.runFilter(query),
                                  onSubmitted: (query) =>
                                      provider.runFilter(query),
                                ),
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
                                        child: CustomScrollView(
                                          shrinkWrap: true,
                                          slivers: [
                                            CupertinoSliverRefreshControl(
                                              onRefresh: () async {
                                                await context
                                                    .read<PostsListProvider>()
                                                    .fetshUserPosts(
                                                        widget.userId);
                                              },
                                            ),
                                            SliverList.builder(
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
                                                      logger.e(
                                                          'element not found');
                                                      return null;
                                                    }
                                                  });
                                                  return PostEditWidget(
                                                      onLongPressed: () {
                                                        showOptionsPopUp(
                                                            context,
                                                            provider,
                                                            post.id!,
                                                            post,
                                                            widget.userId);
                                                      },
                                                      type: UseType.edit,
                                                      post: post,
                                                      countryInfo: country,
                                                      onClicked: () => context.push(
                                                          '/post_edit/${post.id}'));
                                                })
                                          ],
                                          // child: postsList(posts, provider),
                                        ),
                                      )
                              ]),
                            )),
              )),
    );
  }

  Future<dynamic> showOptionsPopUp(BuildContext context,
      PostsListProvider provider, String postId, Post post, String userId) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () {
                      final newStatus = post.status == 'Approved'
                          ? 'Out Of Order'
                          : 'Approved';
                      post.status != 'Approved' && post.status != 'Out Of Order'
                          ? indicativeDialog(
                              context,
                              'Your post should be approved by admins first !',
                              'Ok')
                          : (provider.setOutOfOrder(
                              {'_id': post.id, 'status': newStatus},
                              onSuccess: (res) {
                              logger.i(res);
                              context.pop();
                              provider.localySetStatus(newStatus, postId);
                            }, onFail: (e) {
                              logger.e(e);
                              indicativeDialog(
                                  context, 'Something went wrong', 'Cancel');
                            }));
                    },
                    child: const Text('Set Out Of Order',
                        style: TextStyle(color: CupertinoColors.white))),
                CupertinoActionSheetAction(
                    onPressed: () => showDeleteDialog((context) {
                          provider.deletePost(postId, onSuccess: (message) {
                            logger.i('message $message');
                            context.pop();
                            context.pop();
                            indicativeDialog(
                                context, 'Post deleted with success', 'Ok');
                            provider.fetshUserPosts(userId);
                          }, onFail: (e) {
                            // logger.e(e);
                            context.pop();
                            context.pop();
                            indicativeDialog(
                                context,
                                'Something went wrong deleting this post',
                                'Cancel');
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

  Future<dynamic> indicativeDialog(
      BuildContext context, String message, String buttonText) {
    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              content: Text(
                message,
                style:
                    const TextStyle(color: CupertinoColors.white, fontSize: 16),
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(
                    buttonText,
                  ),
                  onPressed: () => context.pop(),
                )
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
