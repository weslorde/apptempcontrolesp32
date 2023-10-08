import '../../lib2/src/shared/themes/color_schemes.g.dart';
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
          icon: Icon(Icons.data_usage, color: IconColorChange(0)),
          label: "Monitorar"),
      NavigationDestination(
          icon: Icon(Icons.alarm_on, color: IconColorChange(1)), label: "Alarmes"),
      NavigationDestination(icon: Icon(Icons.format_line_spacing, color: IconColorChange(2)), label: "Controle"),
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
