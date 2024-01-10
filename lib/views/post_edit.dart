import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/types.dart';
import 'package:realestate/providers/post_edit_provider.dart';
import 'package:realestate/views/error_widget.dart';

import '../models/core/post/post.dart';

class PostEditPage extends StatefulWidget {
  final String postId;
  const PostEditPage({required this.postId, super.key});

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostEditProvider>().fetshPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Post Edit'),
      ),
      child: Consumer<PostEditProvider>(
          builder: (context, provider, _) => provider.loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : provider.post.fold(
                  (l) => ErrorScreen(
                      refreshFunction: provider.fetshPost(widget.postId),
                      message: 'Error getting post data'), (post) {
                  if (provider.firstTime) {
                    provider.postBuilder = post.toMap();
                    provider.firstTime = false;
                  }
                  return SafeArea(
                    child: Column(
                      children: [
                        CupertinoButton(
                          onPressed: () => showTypePicker(provider),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Propriety Type : ',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              Text(provider.postBuilder['type']),
                            ],
                          ),
                        ),
                        CupertinoTextField()
                      ],
                    ),
                  );
                })),
    );
  }

  showTypePicker(PostEditProvider provider) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: availableTypes
                  .map((type) => GestureDetector(
                        onTap: () {
                          provider.setPostBuilderField('type', type);
                          provider.setType(type);
                          context.pop();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(type)),
                      ))
                  .toList(),
            ));
  }
}
