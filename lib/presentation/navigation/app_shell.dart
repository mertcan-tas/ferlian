import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../providers/bottom_nav_provider.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    ExploreScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  Widget _buildNavIcon(String assetName, Color color) {
    return SvgPicture.asset(
      'assets/icons/$assetName',
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  List<PersistentBottomNavBarItem> _navBarItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inactiveColor =
        colorScheme.onSurfaceVariant.withValues(alpha: 0.7);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    );

    return [
      PersistentBottomNavBarItem(
        icon: _buildNavIcon('compass.svg', colorScheme.primary),
        inactiveIcon: _buildNavIcon('compass.svg', inactiveColor),
        title: 'Discover',
        activeColorPrimary: colorScheme.primary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: inactiveColor,
        inactiveColorSecondary: inactiveColor,
        textStyle: labelStyle,
        iconSize: 24,
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: _buildNavIcon('heart.svg', colorScheme.primary),
        inactiveIcon: _buildNavIcon('heart.svg', inactiveColor),
        title: 'Matches',
        activeColorPrimary: colorScheme.primary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: inactiveColor,
        inactiveColorSecondary: inactiveColor,
        textStyle: labelStyle,
        iconSize: 24,
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: _buildNavIcon('chat.svg', colorScheme.primary),
        inactiveIcon: _buildNavIcon('chat.svg', inactiveColor),
        title: 'Chat',
        activeColorPrimary: colorScheme.primary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: inactiveColor,
        inactiveColorSecondary: inactiveColor,
        textStyle: labelStyle,
        iconSize: 24,
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: _buildNavIcon('user.svg', colorScheme.primary),
        inactiveIcon: _buildNavIcon('user.svg', inactiveColor),
        title: 'Profile',
        activeColorPrimary: colorScheme.primary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: inactiveColor,
        inactiveColorSecondary: inactiveColor,
        textStyle: labelStyle,
        iconSize: 24,
        contentPadding: 0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, navigation, _) {
        return PersistentTabView(
          context,
          controller: navigation.controller,
          screens: _screens,
          items: _navBarItems(context),
          onItemSelected: navigation.onItemTapped,
          navBarStyle: NavBarStyle.style7,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
          backgroundColor: Theme.of(context).colorScheme.surface,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.zero,
            colorBehindNavBar: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              width: 0.8,
            ),
          ),
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              animateTabTransition: true,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 250),
              screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          resizeToAvoidBottomInset: true,
          stateManagement: false,
          confineToSafeArea: true,
        );
      },
    );
  }
}
