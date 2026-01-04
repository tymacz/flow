import 'package:flow/home_page.dart';
import 'package:flow/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
        return [
          HomePage(),
          screen2(),
          screen3(),
          screen4(),
        ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: Icon(Icons.home),
                inactiveIcon: Icon(Icons.home_outlined),
                title: ("Accueil"),
                activeColorPrimary: Color(0xFF6366F1),
                inactiveColorPrimary: Color.fromARGB(255, 108, 122, 141),
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.fitness_center),
                inactiveIcon: Icon(Icons.fitness_center_outlined),
                title: ("Exercices"),
                activeColorPrimary: Color(0xFF6366F1),
                inactiveColorPrimary: Color.fromARGB(255, 108, 122, 141),
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.analytics),
                inactiveIcon: Icon(Icons.analytics_outlined),
                title: ("Progression"),
                activeColorPrimary: Color(0xFF6366F1),
                inactiveColorPrimary: Color.fromARGB(255, 108, 122, 141),
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.person),
                inactiveIcon: Icon(Icons.person_outline),
                title: ("Profil"),
                activeColorPrimary: Color(0xFF6366F1),
                inactiveColorPrimary: Color.fromARGB(255, 108, 122, 141),
            ),
        ];
    }
    PersistentTabController _controller;

_controller = PersistentTabController(initialIndex: 0);
    return  PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true, 
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        padding: const EdgeInsets.only(top: 8),
        backgroundColor: Color(0xFFFFFFFF),
        isVisible: true,
        animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings( 
                animateTabTransition: true,
                duration: Duration(milliseconds: 200),
                screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
            ),
        ),
        confineToSafeArea: true,
        navBarHeight: kBottomNavigationBarHeight,
        navBarStyle: NavBarStyle.style3,
      );
  }
}

class screen1 extends StatelessWidget {
  const screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 1'),
      ),
      body: const Center(
        child: Text('This is Screen 1'),
      ),
    );
  }
}

class screen2 extends StatelessWidget {
  const screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 2'),
      ),
      body: const Center(
        child: Text('This is Screen 2'),
      ),
    );
  }
}

class screen3 extends StatelessWidget {
  const screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 3'),
      ),
      body: const Center(
        child: Text('This is Screen 3'),
      ),
    );
  }
}

class screen4 extends StatelessWidget {
  const screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 4'),
      ),
      body: const Center(
        child: Text('This is Screen 4'),
      ),
    );
  }
}



