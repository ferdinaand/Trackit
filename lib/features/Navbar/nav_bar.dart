import 'dart:async';

import 'package:TrackIt/features/Extras/extras_screen.dart';
import 'package:TrackIt/features/Navbar/navbar_code.dart';
import 'package:TrackIt/Resources/res.dart';
import 'package:TrackIt/features/ai_assist/presentation/ai_assistant.dart';
import 'package:TrackIt/features/report/Report.dart';
import 'package:TrackIt/features/Create_budget/new_transaction_form.dart';
import 'package:TrackIt/features/home/presentation/home_screen.dart';
import 'package:TrackIt/global_widgets/widgets/report_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatefulWidget {
  static const String routeName = "/navBar";

  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with WidgetsBindingObserver {
  // late Timer _inactivityTimer;
  // DateTime? _lastPausedTime;

  // PersistentTabController _controller;
  // final PersistentTabController _controller =
  //     PersistentTabController(initialIndex: 0);

  int selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: selectedIndex);
    WidgetsBinding.instance.addObserver(this);
    // _startInactivityTimer();
  }

  // void _startInactivityTimer() {
  //   _inactivityTimer = Timer.periodic(const Duration(minutes: 25), (timer) {
  //     _navigateToAuthScreen();
  //   });
  // }

  // void _navigateToAuthScreen() {
  //   // Cancel the timer when navigating away
  //   _inactivityTimer.cancel();
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (_) => const AuthScreen()));
  // }

  // void _resetInactivityTimer() {
  //   _inactivityTimer.cancel();
  //   _startInactivityTimer();
  // }

  @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //     // Record when the app goes into the background
  //     _lastPausedTime = DateTime.now();
  //     _inactivityTimer
  //         .cancel(); // Cancel the timer as it won't tick in background
  //   } else if (state == AppLifecycleState.resumed) {
  //     // App is back in the foreground, check if threshold exceeded
  //     final now = DateTime.now();
  //     if (_lastPausedTime != null) {
  //       final difference = now.difference(_lastPausedTime!).inSeconds;
  //       if (difference >= 120) {
  //         // Adjust the threshold based on your needs
  //         _navigateToAuthScreen();
  //       } else {
  //         _resetInactivityTimer(); // Restart the timer if threshold not exceeded
  //       }
  //     }
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _inactivityTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final bool isDarkMode = ref.watch(themeSwitchProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _listOfWidget,
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          //  FadeInSlide(
          //   duration: 1,
          //   direction: FadeSlideDirection.btt,
          //   child:
          FloatingNavbar(
        onTap: (int val) {
          // _resetInactivityTimer();

          setState(() => selectedIndex = val);

          HapticFeedback.lightImpact();

          setState(() {
            selectedIndex = val;
          });
          _pageController.animateToPage(selectedIndex,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInCubic);
        },

        borderColor: colorScheme.outline,
        currentIndex: selectedIndex,
        borderRadius: 20.r,
        itemBorderRadius: 12.r,
        selectedItemColor: colorScheme.inversePrimary,
        // fontSize: MediaQuery.of(context).size.width > 800 ? 14 : 10,
        backgroundColor: colorScheme.onSurface,
        selectedBackgroundColor: colorScheme.onSurface,
        padding: EdgeInsets.all(4),
        // elevation: 8,
        margin: EdgeInsets.zero,
        iconSize: 20.h,
        unselectedItemColor: colorScheme.onPrimary,
        items: [
          FloatingNavbarItem(icon: "assets/png/home.png", title: 'Home'),
          FloatingNavbarItem(icon: "assets/png/report.png", title: 'Report'),
          FloatingNavbarItem(icon: "assets/png/add.png", title: 'Add'),
          FloatingNavbarItem(icon: "assets/png/ai.png", title: 'Ai assist'),
          FloatingNavbarItem(icon: "assets/png/extra.png", title: 'Extra'),
        ],
        // ),
      ),
    );
  }
}

List<Widget> _listOfWidget = <Widget>[
  HomeScreen(),
  Report(),
  NewTransactionForm(onClose: () {}),
  AiAssistanScreen(),
  ExtrasScreen(),
];
