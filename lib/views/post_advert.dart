import 'package:flutter/cupertino.dart';

class PostAdvert extends StatelessWidget {
  const PostAdvert({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Post Advert')),
      child: Center(
        child: Text('post advert'),
      ),
    );
  }
}
