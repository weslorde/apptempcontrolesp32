import 'package:apptempcontrolesp32/src/shared/themes/color_schemes.g.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar(
      {super.key, this.currentIndex = 0, required this.onNavBarClicked});

  final int currentIndex;
  final void Function(int index) onNavBarClicked;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Color IconColorChange(int n) {
    if( widget.currentIndex == n ){
      return darkColorScheme.background;
    }
    else {return darkColorScheme.primary;}
    
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> destinations = [
      NavigationDestination(
          icon: Icon(Icons.fireplace_outlined, color: IconColorChange(0)),
          label: "Faier"),
      NavigationDestination(
          icon: Icon(Icons.water_drop_outlined, color: IconColorChange(1)), label: "Water"),
      NavigationDestination(icon: Icon(Icons.group_add, color: IconColorChange(2)), label: "Team"),
    ];

    return NavigationBar(
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: [...destinations],
      selectedIndex: widget.currentIndex,
      onDestinationSelected: widget.onNavBarClicked,
    );
  }
}
