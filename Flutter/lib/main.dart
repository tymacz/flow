import 'package:flow/pages/activity_page.dart';
import 'package:flow/pages/articles_page.dart';
import 'package:flow/pages/home_page.dart';
import 'package:flow/pages/profil_page.dart';
import 'package:flow/pages/progress_page.dart';
import 'package:flow/pages/splash_page.dart';
import 'package:flow/widgets/network_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async { // <--- Ajoute async
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 👇 INITIALISATION SUPABASE (Remplace par TES clés)
  await Supabase.initialize(
    url: 'https://byxhmtkvstrvpljeawaa.supabase.co', 
    anonKey: 'sb_publishable_B73v7SqnOBYrOObTe9nmFA_f4RschCJ', 
  );

  runApp(const ProviderScope(
      child: MyApp(),
  ));
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
    PersistentTabController _controller = PersistentTabController(initialIndex: 0);
    List<Widget> _buildScreens() {
    return [
        NetworkWrapper(
          child: HomePage(
            onSettingsPressed: () {
              _controller.jumpToTab(4); 
            },
            onPressedCatalogue: (){
              _controller.jumpToTab(1);
            },
          ),
        ),
        const ActivityPage(),
        const ArticlesPage(),
        const ProgressPage(),
        const ProfilPage(),
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
                icon: Icon(Icons.self_improvement),
                inactiveIcon: Icon(Icons.self_improvement_outlined),
                title: ("Exercices"),
                activeColorPrimary: Color(0xFF6366F1),
                inactiveColorPrimary: Color.fromARGB(255, 108, 122, 141),
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.article),
                inactiveIcon: Icon(Icons.article_outlined),
                title: ("Articles"),
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



