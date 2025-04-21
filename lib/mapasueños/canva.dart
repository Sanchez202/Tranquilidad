import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';

class CanvasEditor extends StatefulWidget {
  const CanvasEditor({Key? key}) : super(key: key);

  @override
  State<CanvasEditor> createState() => _CanvasEditorState();
}

class _CanvasEditorState extends State<CanvasEditor> {
  int _selectedIndex = 1;
  int _selectedToolIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onToolSelected(int index) {
    setState(() {
      _selectedToolIndex = index == _selectedToolIndex ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        body: Container(
          color: Color(0xFFFFF5F5), // Color rosa muy claro como en la imagen
          child: Center(
            child: Text(
              _selectedToolIndex >= 0 ? 'Herramienta ${_selectedToolIndex + 1} seleccionada' : 'Selecciona una herramienta',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Editor toolbar
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToolIcon(0, Icons.image_outlined),
                  _buildToolIcon(1, Icons.text_fields_outlined),
                  _buildToolIcon(2, Icons.edit_outlined),
                  _buildToolIcon(3, Icons.category_outlined),
                  _buildToolIcon(4, Icons.layers_outlined),
                  _buildToolIcon(5, Icons.auto_fix_high_outlined),
                ],
              ),
            ),
            // Custom navigation bar
            CustomNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolIcon(int index, IconData icon) {
    final bool isSelected = _selectedToolIndex == index;
    
    return InkWell(
      onTap: () => _onToolSelected(index),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.grey.shade700,
          size: 24,
        ),
      ),
    );
  }
}