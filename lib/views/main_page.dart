import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/home_page_provider.dart';
import 'package:realestate/views/home_page.dart';
import 'package:realestate/views/liked_page.dart';
import '../providers/auth_provider.dart';
import 'post_advert_preview.dart';

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

  //todo add backstack logic
  int currentIndex = 0;
  // final visited = <int>[];
  final List<Widget> _pagesList = [
    HomePage(),
    const LikedPage(),
    const PostAdvertButtonPage()
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        inactiveColor: CupertinoColors.white,
        // currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_favorites_alt), label: 'Liked'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.plus_app_fill), label: 'Post advert'),
        ],
        onTap: (index) {
          if (index == 0 && currentIndex == 0) {
            context.read<HomePageProvider>().scrollToTop();
          }
          currentIndex = index;
        },
        // onTap: (index) {
        //   if (index != currentIndex) {
        //     visited.add(index);
        //     logger.i(visited);
        //   }
        //   currentIndex = index;
        // },
      ),
      tabBuilder: (context, index) => _pagesList[index],
    );
  }
}
