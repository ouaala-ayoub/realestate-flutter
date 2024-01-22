import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class PostCreated extends StatelessWidget {
  const PostCreated({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.checkmark_circle_fill,
              size: 50,
              color: CupertinoColors.activeGreen,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Post Created with success',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CupertinoButton(
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(CupertinoIcons.back),
                  Text(
                    'Back',
                  )
                ]),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
