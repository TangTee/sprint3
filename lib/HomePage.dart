import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/utils/color.dart';
import 'chat/chat-landing.dart';
import 'event/Event.dart';
import 'feed/FeedPage.dart';
import 'Profile/Profile.dart';
import 'activity/Activity.dart';

class MyHomePage extends StatelessWidget {
  final int index ;
  const MyHomePage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        const HomeTab(),
        const ActivityTab(),
        const Event(),
        const ChatTab(),
        const ProfileTab(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.home,
            size: 30,
          ),
          title: ("Home"),
          activeColorPrimary: lightGreen,
          inactiveColorPrimary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.history,
            size: 30,
          ),
          title: ("Activity"),
          activeColorPrimary: lightGreen,
          inactiveColorPrimary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.add_circle,
            size: 30,
          ),
          title: ("Post"),
          activeColorPrimary: lightGreen,
          inactiveColorPrimary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.chat,
            size: 30,
          ),
          title: ("Chat"),
          activeColorPrimary: lightGreen,
          inactiveColorPrimary: primaryColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.account_circle,
            size: 30,
          ),
          title: ("Proflie"),
          activeColorPrimary: lightGreen,
          inactiveColorPrimary: primaryColor,
        ),
      ];
    }

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: index);
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarsItems(),
      controller: controller,
      confineInSafeArea: true,
      backgroundColor: purple,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: purple,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}

class Event extends StatelessWidget {
  const Event({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreateEventScreen(),
    );
  }
}

class ActivityTab extends StatelessWidget {
  const ActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ActivityPage(),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedPage(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
    );
  }
}

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatHomePage(),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ProfilePage(uid: FirebaseAuth.instance.currentUser!.uid));
  }
}
