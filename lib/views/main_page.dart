import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/home_page_provider.dart';
import 'package:realestate/providers/liked_provider.dart';
import 'package:realestate/views/add_post_page.dart';
import 'package:realestate/views/home_page.dart';
import 'package:realestate/views/liked_page.dart';

import '../providers/auth_provider.dart';

// todo search provider with search widget test

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    context.read<RealestateAuthProvider>().fetshAuth();
  }

  final _pagesList = [
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
      ],
      child: const HomePage(),
    ),
    ChangeNotifierProvider(
      create: (context) => LikedPageProvider(),
      child: LikedPage(),
    ),
    AddPostPage()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_favorites_alt), label: 'Liked'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.plus_app_fill), label: 'Post advert'),
      ]),
      tabBuilder: (context, index) => _pagesList[index],
    );
  }
}
