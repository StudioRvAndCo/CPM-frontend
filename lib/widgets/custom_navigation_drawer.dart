import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({super.key, required this.onNavigate, required this.selectedIndex});

  final void Function(int) onNavigate;

  final int selectedIndex;

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: NavigationDrawer(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            widget.onNavigate(index);
            Navigator.pop(context);
          });
        },
        children: <Widget>[
          DrawerHeader(
            child: Builder(builder: (BuildContext context) {
              if (Theme.of(context).brightness == Brightness.light) {
                return Image.asset(
                  'assets/images/logo-cpm-alpha.png',
                  width: 50,
                  filterQuality: FilterQuality.high,
                );
              } else {
                return Image.asset(
                  'assets/images/logo-cpm-white-alpha.png',
                  width: 50,
                  filterQuality: FilterQuality.high,
                );
              }
            }),
          ),
          NavigationDrawerDestination(icon: const Icon(Icons.home_outlined), label: Text('home'.tr())),
          NavigationDrawerDestination(
              icon: const Icon(Icons.people_outline), label: Text('members.member.upper'.plural(2))),
          NavigationDrawerDestination(icon: const Icon(Icons.map), label: Text('locations.location.upper'.plural(2))),
          NavigationDrawerDestination(icon: const Icon(Icons.settings), label: Text('settings.settings'.tr())),
          NavigationDrawerDestination(icon: const Icon(Icons.info), label: Text('about.about'.tr())),
          const NavigationDrawerDestination(icon: Icon(Icons.quiz), label: Text('Test')),
        ],
      ),
    );
  }
}
