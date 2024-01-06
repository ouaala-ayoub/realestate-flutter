import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/post/post.dart';
import 'package:realestate/providers/auth_provider.dart';
import 'package:realestate/providers/post_page_provider.dart';
import 'package:realestate/providers/report_provider.dart';
import 'package:realestate/providers/search_provider.dart';
import 'package:realestate/views/post_page.dart';
import 'package:realestate/views/report_page.dart';
import 'package:realestate/views/settings_page.dart';
import 'firebase_options.dart';
import 'providers/firebase_constants.dart';
import 'views/main_page.dart';
import 'views/filter_page.dart';

final logger = Logger();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    //todo change
    GoogleProvider(
      clientId:
          '714414033482-sd39ihttit3sii0604f5rq1h3akgbtsr.apps.googleusercontent.com',
    ),
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final config = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainPage(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const FilterPage()),
    GoRoute(
        path: '/postPage',
        builder: (context, state) => ChangeNotifierProvider(
              create: (context) => PostPageProvider(),
              child: PostPage(
                post: state.extra as Post,
              ),
            )),
    GoRoute(
        path: '/report/:id',
        builder: (context, state) => ChangeNotifierProvider(
              create: (context) => ReportPageProvider(),
              child: ReportPage(id: state.pathParameters['id']!),
            )),
    GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
            child: SettingsPage(),
            transitionsBuilder: (context, an1, an2, child) =>
                FadeTransition(opacity: an1, child: child)))
  ]);
//  builder: (context, state) => SettingsPage()
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => RealestateAuthProvider())
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