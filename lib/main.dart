import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/auth_provider.dart';
import 'package:realestate/providers/home_page_provider.dart';
import 'package:realestate/providers/liked_provider.dart';
import 'package:realestate/providers/looking_for_edit_provider.dart';
import 'package:realestate/providers/looking_for_provider.dart';
import 'package:realestate/providers/post_edit_provider.dart';
import 'package:realestate/providers/post_page_provider.dart';
import 'package:realestate/providers/posts_list_provider.dart';
import 'package:realestate/providers/report_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/looking_for_post_edit.dart';
import 'package:realestate/views/post_created.dart';
import 'package:realestate/views/post_edit.dart';
import 'package:realestate/views/post_page.dart';
import 'package:realestate/views/profile_page.dart';
import 'package:realestate/views/report_page.dart';
import 'package:realestate/views/settings_page.dart';
import 'package:realestate/views/shared_post_advert_stepper.dart';
import 'firebase_options.dart';
import 'providers/post_advert_provider.dart';
import 'views/main_page.dart';
import 'views/filter_page.dart';

final logger = Logger();
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    //todo change
    GoogleProvider(
      clientId: dotenv.env['CLIENT_ID']!,
    ),
  ]);
  FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final config = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const FilterPage()),
    GoRoute(
      path: '/postPage/:id',
      builder: (context, state) => ChangeNotifierProvider(
        create: (context) =>
            PostPageProvider((state.extra as Map<String, dynamic>)['post']),
        child: PostPage(
          postId: state.pathParameters['id']!,
          countryInfo: (state.extra as Map<String, dynamic>)['country_info'],
        ),
      ),
    ),
    GoRoute(
        path: '/report/:id',
        builder: (context, state) => ChangeNotifierProvider(
              create: (context) => ReportPageProvider(),
              child: ReportPage(id: state.pathParameters['id']!),
            )),
    GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
            child: const SettingsPage(),
            transitionsBuilder: (context, an1, an2, child) =>
                FadeTransition(opacity: an1, child: child))),
    GoRoute(
        path: '/profile/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChangeNotifierProvider(
            create: (context) => PostsListProvider(),
            child: ProfilePage(
              userId: id,
            ),
          );
        }),
    GoRoute(
        path: '/post_edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChangeNotifierProvider(
            create: (context) => PostEditProvider(),
            child: PostEditPage(
              postId: id,
            ),
          );
        }),
    GoRoute(
        path: '/looking_for_post_edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChangeNotifierProvider(
            create: (context) => LookingForPostEditProvider(),
            child: LookingForPostEdit(
              postId: id,
            ),
          );
        }),
    GoRoute(
      path: '/post_advert/:ownerId',
      builder: (context, state) {
        final userId = state.pathParameters['ownerId']!;
        return ChangeNotifierProvider(
          create: (context) => PostAdvertProvider(),
          child: Consumer<PostAdvertProvider>(
            builder: (context, provider, _) => PostAdvertTest(
              ownerId: userId,
              successRoute: '/post_created',
              pageTitle: 'Post Advert ( Rent/ Forsale )',
              loaderProvider: provider,
            ),
          ),
        );
      },
    ),
    GoRoute(
        path: '/looking_for_advert/:ownerId',
        builder: (context, state) {
          final userId = state.pathParameters['ownerId']!;
          return ChangeNotifierProvider(
            create: (context) => LookingForProvider(),
            child: Consumer<LookingForProvider>(
              builder: (context, provider, _) => PostAdvertTest(
                ownerId: userId,
                successRoute: '/post_created',
                pageTitle: 'Looking for',
                loaderProvider: provider,
              ),
            ),
          );
        }),
    GoRoute(
        path: '/post_created', builder: (context, state) => const PostCreated())
  ]);
//  builder: (context, state) => SettingsPage()
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => RealestateAuthProvider()),
        ChangeNotifierProvider(create: (context) => LikedPageProvider()),
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
      ],
      child: CupertinoApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: const CupertinoThemeData(
          brightness: Brightness.dark, primaryColor: Color(0xffffd60a),
          // barBackgroundColor: Color(0xffffd60a),
        ),
        routerConfig: config,
      ),
    );
  }
}
