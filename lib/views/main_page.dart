import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
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
  final controller = CupertinoTabController(initialIndex: 0);
  // final visited = <int>[];
  final List<Widget> _pagesList = [
    const HomePage(),
    const LikedPage(),
    const PostAdvertButtonPage()
  ];
  @override
  Widget build(BuildContext buildContext) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        logger.d(didPop);
        if (controller.index != 0) {
          setState(() {
            controller.index = 0;
          });
        } else {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Exit'),
              content: const Text(
                'Are you sure you want to leave the application ?',
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text('Yes'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'No',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          );
        }
      },
      child: CupertinoTabScaffold(
        controller: controller,
        tabBar: CupertinoTabBar(
          inactiveColor: CupertinoColors.white,
          // currentIndex: currentIndex,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_favorites_alt),
              label: 'Liked',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.plus_app_fill),
              label: 'Post advert',
            ),
          ],
          onTap: (index) {
            if (index == 0 && controller.index == 0) {
              context.read<HomePageProvider>().scrollToTop();
            }
            setState(() {
              controller.index = index;
            });
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
      ),
    );
  }
}
