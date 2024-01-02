import 'package:florascan/src/modules/home/index.dart';
import 'package:florascan/src/widgets/list_tile/list_tile_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../services/helpers.dart';

class FrontFrame extends StatefulWidget {
  const FrontFrame({super.key});

  @override
  State<FrontFrame> createState() => _FrontFrameState();
}

class _FrontFrameState extends State<FrontFrame> {
  late PersistentTabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  // Screen
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary:
            isDarkTheme(context) ? Colors.white : CustomColor.primary,
        inactiveColorPrimary: isDarkTheme(context)
            ? CustomColor.darkBg
            : CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.camera),
        title: ("Scan Disease"),
        activeColorPrimary:
            isDarkTheme(context) ? Colors.white : CustomColor.primary,
        inactiveColorPrimary: isDarkTheme(context)
            ? CustomColor.darkBg
            : CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.info_circle_fill),
        title: ("Plant Info"),
        activeColorPrimary:
            isDarkTheme(context) ? Colors.white : CustomColor.primary,
        inactiveColorPrimary: isDarkTheme(context)
            ? CustomColor.darkBg
            : CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.news_solid),
        title: ("News"),
        activeColorPrimary:
            isDarkTheme(context) ? Colors.white : CustomColor.primary,
        inactiveColorPrimary: isDarkTheme(context)
            ? CustomColor.darkBg
            : CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Placeholder(),
            ),
            // Account
            listTileIcon(
              context: context,
              icon: CupertinoIcons.person_fill,
              title: "Account",
              onTap: () {},
            ),
            // Security (Password, Login activity)
            listTileIcon(
              context: context,
              icon: CupertinoIcons.shield_lefthalf_fill,
              title: "Security",
              onTap: () {},
            ),
            // Theme
            listTileIcon(
              context: context,
              icon: isDarkTheme(context)
                  ? CupertinoIcons.moon_fill
                  : CupertinoIcons.sun_max_fill,
              title: "Theme",
              onTap: () => selectThemeMode(context),
            ),
            // Admin Panel
            listTileIcon(
              context: context,
              icon: Icons.admin_panel_settings,
              title: "Admin Menu",
              onTap: () {},
            ),
            Divider(
              height: 20,
              color: isDarkTheme(context)
                  ? CustomColor.darkBg
                  : CupertinoColors.systemGrey,
            ),
            // Login/Logout
            ListTile(
              title: const Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.logout,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: '  ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: [
          Home(
            mainContext: context,
            scaffoldKey: _scaffoldKey,
          ),
          const Placeholder(),
          const Placeholder(),
          const Placeholder(),
        ],
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor:
            isDarkTheme(context) ? CustomColor.primary : Colors.white,
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar:
              isDarkTheme(context) ? CustomColor.darkerBg : Colors.white,
          boxShadow: isDarkTheme(context)
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style12, // Choose the nav bar style with this property.
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}