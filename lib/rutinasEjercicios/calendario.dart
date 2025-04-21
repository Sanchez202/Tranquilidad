import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 1; // Mantiene la coherencia con la navegación existente
  int selectedDay = 3; // Día seleccionado en el calendario
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navegar a Módulos
    } else if (index == 2) {
      // Navegar a Perfil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(), // Usando tu CustomAppBar
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondo_tranquilidad.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay para mejorar contraste
          Container(color: Colors.white.withOpacity(0.85)),
          
          // Contenido principal
          Padding(
            padding: const EdgeInsets.only(bottom: 70, top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de navegación de tabs
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTab('INICIO', false),
                        const SizedBox(width: 8),
                        _buildTab('CALENDARIO', true),
                        const SizedBox(width: 8),
                        _buildTab('FAVORITOS', false),
                        const SizedBox(width: 8),
                        _buildTab('NOTIFICACIONES', false),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Título del mes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'May 2023',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Calendario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Días de la semana
                      Row(
                        children: [
                          _buildDayOfWeekHeader('Do'),
                          _buildDayOfWeekHeader('Lu'),
                          _buildDayOfWeekHeader('Ma'),
                          _buildDayOfWeekHeader('Mi'),
                          _buildDayOfWeekHeader('Ju'),
                          _buildDayOfWeekHeader('Vi'),
                          _buildDayOfWeekHeader('Sa'),
                        ],
                      ),
                      
                      // Filas del calendario
                      _buildCalendarRow([1, 2, 3, 4, 5, 6, 7]),
                      _buildCalendarRow([8, 9, 10, 11, 12, 13, 14]),
                      _buildCalendarRow([15, 16, 17, 18, 19, 20, 21]),
                      _buildCalendarRow([22, 23, 24, 25, 26, 27, 28]),
                      _buildCalendarRow([29, 30, 31, 0, 0, 0, 0]),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Botón de Tareas
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lista de tareas'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF59009A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'TAREAS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Usar tu CustomNavBar
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: const Color(0xFF59009A),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF59009A) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDayOfWeekHeader(String day) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarRow(List<int> days) {
    return Row(
      children: days.map((day) {
        bool isEmpty = day == 0;
        bool isSelected = day == selectedDay;
        
        Color backgroundColor = Colors.transparent;
        if (isSelected) {
          backgroundColor = const Color(0xFF59009A);
        } else if (day == 1) {
          backgroundColor = const Color(0xFFDCD4F3);
        }
        
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.center,
              child: isEmpty
                  ? const SizedBox()
                  : Text(
                      day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
