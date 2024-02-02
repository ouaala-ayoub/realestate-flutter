import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/post_advert_provider.dart';
import 'package:realestate/views/images_selected_widget.dart';
import '../../models/core/constants.dart';

class PostAdvertImagesStep extends StatelessWidget {
  const PostAdvertImagesStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostAdvertProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Center(
            child: CupertinoButton.filled(
              disabledColor: CupertinoColors.quaternarySystemFill,
              child: const Text(
                'Select Images',
                style: TextStyle(
                    color: CupertinoColors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (provider.data['media'].length >= maxFilesLimit) {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                            actions: [
                              CupertinoDialogAction(
                                  onPressed: () => context.pop(),
                                  isDestructiveAction: true,
                                  child: const Text('Cancel'))
                            ],
                            content: const Text(
                              'File Limit Reached !',
                              style: TextStyle(fontSize: 18),
                            ),
                          ));

                  return;
                }
                provider.pickImages(onPicked: (files) {
                  for (var element in files) {
                    if (provider.data['media'].length < maxFilesLimit) {
                      provider.addFile(element);
                    }
                  }
                  provider.notify();
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
              ),
              itemCount: provider.data['media']!.length,
              itemBuilder: (context, index) => GestureDetector(
                  onLongPress: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      provider.deleteImageAtIndex(index);
                                      context.pop();
                                    },
                                    isDestructiveAction: true,
                                    child: const Text(
                                      'Remove',
                                    )),
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: CupertinoColors.white),
                                    ))
                              ],
                            ));
                  },
                  child: SelectedImage(xfile: provider.data['media'][index]))),
          !provider.canContinue[0]
              ? const Text(
                  'Please Enter images !',
                  style: TextStyle(color: CupertinoColors.systemRed),
                )
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Less than 100mb',
            style: TextStyle(
              color: CupertinoColors.systemYellow,
              fontSize: 18,
            ),
          ),
          const Text(
            '10 Images Max',
            style: TextStyle(
                color: CupertinoColors.systemYellow,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const Text('Jpg, Jpeg, Png, WabP, Mp4 or WebM'),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
