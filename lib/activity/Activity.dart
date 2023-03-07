import 'package:flutter/material.dart';
import 'package:tangteevs/activity/favorite.dart';
import 'package:tangteevs/activity/history.dart';
import 'package:tangteevs/activity/waiting.dart';
import 'package:tangteevs/utils/color.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            elevation: 1,
            centerTitle: false,
            title: Image.asset(
              "assets/images/logo with name.png",
              width: MediaQuery.of(context).size.width * 0.31,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: purple,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ],
            bottom: const TabBar(
              indicatorColor: green,
              labelColor: green,
              labelPadding: EdgeInsets.symmetric(horizontal: 25),
              unselectedLabelColor: unselected,
              labelStyle: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'MyCustomFont'), //For Selected tab
              unselectedLabelStyle: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'MyCustomFont'), //For Un-selected Tabs
              tabs: [
                Tab(text: 'Waiting'),
                Tab(text: 'History'),
                Tab(text: 'Favorite'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Waiting(),
              History(),
              Favorite(),
            ],
          ),
        ));
  }
}

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostCard(),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HistoryPage(),
    );
  }
}

class Waiting extends StatelessWidget {
  const Waiting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WaitingPage(),
    );
  }
}
