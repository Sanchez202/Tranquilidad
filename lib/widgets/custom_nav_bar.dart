import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Color primaryColor;
  
  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.primaryColor = const Color.fromARGB(255, 167, 131, 228),
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, 'Módulos', FontAwesomeIcons.thLarge, 0, '/inicio'),
          _buildNavItem(context, 'Inicio', FontAwesomeIcons.house, 1, '/inicio'),
          _buildNavItem(context, 'Perfil', FontAwesomeIcons.userAlt, 2, '/perfil'),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(BuildContext context, String text, IconData icon, int index, String route) {
    final bool isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        onItemSelected(index);
        context.go(route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: isSelected ? primaryColor : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}