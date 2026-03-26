import 'dart:async';

import 'package:TrackIt/features/Navbar/nav_bar.dart';
import 'package:TrackIt/features/auth/Presentation/getting_started.dart';
import 'package:TrackIt/features/home/presentation/providers/Home_provider.dart';
import 'package:TrackIt/features/providers/category_provider.dart';
import 'package:TrackIt/features/providers/transaction_provider.dart';
import 'package:TrackIt/features/home/presentation/home_screen.dart';
import 'package:TrackIt/global_widgets/text.ui.dart';
import 'package:TrackIt/core/theme/theme_provider.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/Presentation/providers/Authethication_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: '.env');
  String supabaseBaseUrl = dotenv.env['supabaseUrl'] ?? '';
  String key = dotenv.get('supabaseKey');
  String geminiKey = dotenv.get('geminiKey');

  await Supabase.initialize(
    url: supabaseBaseUrl,
    anonKey: key,
  );
  Gemini.init(apiKey: geminiKey);
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
          ChangeNotifierProvider(create: (_) => HomeProvider(prefs)),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ],
        child: MyApp(
          prefs: prefs,
        )),
  );
}

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// bool isChecked = false;

// class PermissionService {
//   final StreamController<PermissionStatus> _permissionController =
//       StreamController.broadcast();

//   Stream<PermissionStatus> get permissionStream => _permissionController.stream;

//   void checkPermissionStatus() async {
//     // print('happens');

//     while (true) {
//       final status = await Permission.location.status;
//       _permissionController.add(status);

//       if (status.isPermanentlyDenied) {
//         // _showPermissionDialog();
//       } else if (status.isDenied) {
//         isChecked ? null : _showPermissionDialog();
//       }

//       await Future.delayed(const Duration(seconds: 60)); // Polling interval
//     }
//   }

//   void _showPermissionDialog() {
//     final context = navigatorKey.currentContext;
//     if (context == null) return;

//     showDialog(
//         context: context,
//         builder: (context) {
//           isChecked = true;
//           return AlertDialog(
//             title: Text("Permission Required"),
//             content: Text("This app needs permissions to function properly."),
//             actions: [
//               TextButton(
//                 onPressed: () => openAppSettings(),
//                 child: Text("Open Settings"),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text("Cancel"),
//               ),
//             ],
//           );
//         }).whenComplete(() {
//       isChecked = false;
//     });
//   }

//   void dispose() {
//     _permissionController.close();
//   }
// }

// final permissionService = PermissionService();

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // permissionService.checkPermissionStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;
    print(isAuthenticated);
    // final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          return MaterialApp(
            // navigatorKey: navigatorKey,
            // navigatorObservers: [routeObserver],
            debugShowCheckedModeBanner: false,
            title: 'Budget Tracker',
            theme: themeProvider.theme,
            themeMode: themeProvider.themeMode,
            // theme: ThemeData(
            //   primarySwatch: Colors.blue,
            //   useMaterial3: true,
            // ),
            home: TrackItSplashScreen(
                tag: "homeScreen",
                child:
                    isAuthenticated ? NavBar() : const GettingStartedScreen()),
          );
        });
  }
}

class TrackItSplashScreen extends StatefulWidget {
  final Widget child;
  const TrackItSplashScreen({
    super.key,
    required this.tag,
    required this.child,
  });
  final String tag;
  @override
  State<TrackItSplashScreen> createState() => _TrackItSplashScreenState();
}

class _TrackItSplashScreenState extends State<TrackItSplashScreen> {
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  // final bool isDarkMode = ref.watch(themeSwitchProvider);
  String appVersion = "";

  @override
  void initState() {
    getAppVersion().then((version) {
      setState(() {
        appVersion = version;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FlutterSplashScreen(
      onInit: () {
        // print("object");
      },
      duration: const Duration(seconds: 5),
      useImmersiveMode: true,
      nextScreen: widget.child,
      splashScreenBody: Scaffold(
        body: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.4, bottom: 20),
            // height: double.infinity,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         colorFilter: ColorFilter.mode(
            //           colorScheme.onSurfaceVariant
            //               .withOpacity(1.0), // Apply red tint with 50% opacity
            //           BlendMode.srcATop, // Blends color with image
            //         ),
            //         image: AssetImage("assets/png/backgroundImg.png"),
            //         fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child:
                      //  Hero(
                      //   // flightShuttleBuilder: ,
                      //   tag: widget.tag,
                      // child:
                      SvgPicture.asset(
                    color: colorScheme.outline,
                    "assets/svg/trackItLogo.svg",
                    height: 60,
                    width: 100,
                  ),
                  // ),
                ),
                TextUi.bodySmallBold(
                  "v$appVersion",
                  color: colorScheme.outline,
                )
              ],
            )),
      ),
    );
  }
}
