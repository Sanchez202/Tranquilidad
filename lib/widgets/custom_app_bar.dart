import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Image.network(
            'https://i.ibb.co/gLfx4qJ0/LOGO.png',
            width: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Text('Mi App', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
