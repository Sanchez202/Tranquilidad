import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class IniciomapaDos extends StatefulWidget {
  const IniciomapaDos({super.key});

  @override
  State<IniciomapaDos> createState() => _mapaState();
}

class _mapaState extends State<IniciomapaDos> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    // Animación de entrada
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuint,
      ),
    );
    
    // Animación de pulso suave continuo
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      home: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo original con mejor calidad
            Image.network(
              'https://i.ibb.co/HTKWVdgx/image.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            
            // Overlay con gradiente para mejorar visibilidad
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                 
                  
                  ],
                ),
              ),
            ),
            
            // Efectos decorativos
            CustomPaint(
              painter: StarfieldPainter(),
              child: Container(),
            ),
            
            // Contenido principal con animación
            SafeArea(
              child: _buildContent(),
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  
                  // Sección de encabezado con animación
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.1, 0.6, curve: Curves.easeOut),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título principal con efecto de sombra para destacar
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Color(0xFFE9DAFF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Text(
                              "Explora tu camino",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                height: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Subtítulo con efecto de vidrio
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "¿A dónde te diriges hoy?",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Primera tarjeta - Mapa de sueños (entrada con retraso)
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.3, 0.8, curve: Curves.easeOut),
                      ),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0.3, 0.8, curve: Curves.easeOutCubic),
                        ),
                      ),
                      child: _buildDreamMapCard(),
                    ),
                  ),
                  
                  SizedBox(height: 25),
                  
                  // Segunda tarjeta - Seguimiento (entrada con mayor retraso)
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.5, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0.5, 1.0, curve: Curves.easeOutCubic),
                        ),
                      ),
                      child: _buildFollowUpCard(),
                    ),
                  ),
                  
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDreamMapCard() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: () {
              // Efecto de pulsación al tocar
          
              context.push('/canva');
            },
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8E44AD).withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius: -8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Stack(
                    children: [
                      // Fondo con efecto de vidrio
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF9C27B0).withOpacity(0.7),
                              Color(0xFF7B1FA2).withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                      
                      // Destellos decorativos
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Patrones decorativos
                      CustomPaint(
                        painter: DreamMapPatternPainter(),
                        size: Size.infinite,
                      ),
                      
                      // Contenido de la tarjeta
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fila superior con ícono y botón de navegación
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Ícono con efecto de vidrio
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.map_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                
                                // Botón de navegación con animación
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.2),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            
                            Spacer(),
                            
                            // Título con etiqueta "Premium"
                            Row(
                              children: [
                                Text(
                                  'Mapa de Sueños',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 8),
                            
                            // Descripción
                            Text(
                              'Crea lienzos personalizados para visualizar tus sueños y convertirlos en realidad',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.4,
                                letterSpacing: 0.3,
                              ),
                            ),
                            
                            SizedBox(height: 15),
                            
                            // Indicadores de funcionalidad
                            Row(
                              children: [
                                _buildFeatureTag(Icons.edit, "Personalizable"),
                                SizedBox(width: 8),
                               
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Elemento decorativo diagonal
                      Positioned(
                        bottom: -50,
                        right: -50,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFFCE93D8).withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFollowUpCard() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: () {
              // Efecto de pulsación al tocar
             
              context.push('/seguimiento');
            },
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3949AB).withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius: -8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Stack(
                    children: [
                      // Fondo con efecto de vidrio
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF3F51B5).withOpacity(0.7),
                              Color(0xFF303F9F).withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                      
                      // Destellos decorativos
                      Positioned(
                        top: -40,
                        right: -40,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Patrones decorativos
                      CustomPaint(
                        painter: FollowUpPatternPainter(),
                        size: Size.infinite,
                      ),
                      
                      // Contenido de la tarjeta
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fila superior con ícono y botón de navegación
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Ícono con efecto de vidrio
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.task_alt,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                
                                // Botón de navegación con animación
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.2),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            
                            Spacer(),
                            
                            // Título con etiqueta "New"
                            Row(
                              children: [
                                Text(
                                  'Seguimiento',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '🚀 New',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 8),
                            
                            // Descripción
                            Text(
                              'Organiza y monitorea tus objetivos con un sistema de tareas personalizado según tus metas',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.4,
                                letterSpacing: 0.3,
                              ),
                            ),
                            
                            SizedBox(height: 15),
                            
                            // Indicadores de funcionalidad
                            Row(
                              children: [
                                _buildFeatureTag(Icons.calendar_today, "Planificación"),
                                SizedBox(width: 8),
                                _buildFeatureTag(Icons.notifications_active, "Recordatorios"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Elemento decorativo diagonal
                      Positioned(
                        bottom: -50,
                        right: -50,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFF9FA8DA).withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  // Widget para etiquetas de características
  Widget _buildFeatureTag(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            color: Colors.white,
            size: 12,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Pintores personalizados para los patrones decorativos

class StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    // Simulación de estrellas o puntos de luz en el fondo
    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 50; i++) {
      final x = ((random * (i + 1)) % size.width.toInt()).toDouble();
      final y = ((random * (i * 3 + 1)) % size.height.toInt()).toDouble();
      final radius = ((random * (i + 5)) % 3) / 10 + 0.5;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DreamMapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // Patrones que sugieren mapas o constelaciones
    for (int i = 0; i < 5; i++) {
      final offset = i * 20.0;
      
      // Líneas conectadas simulando constelaciones
      Path path = Path();
      path.moveTo(size.width * 0.1, size.height * 0.8 - offset);
      path.lineTo(size.width * 0.3, size.height * 0.7 - offset * 0.5);
      path.lineTo(size.width * 0.5, size.height * 0.75 - offset * 0.3);
      path.lineTo(size.width * 0.7, size.height * 0.6 - offset * 0.2);
      
      canvas.drawPath(path, paint);
    }
    
    // Círculos decorativos simulando nodos
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 3, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.7), 2, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.75), 4, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FollowUpPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // Patrones que sugieren listas de tareas o progreso
    final double startX = size.width * 0.8;
    final double startY = size.height * 0.3;
    
    // Líneas horizontales simulando elementos de lista
    for (int i = 0; i < 4; i++) {
      final y = startY + (i * 15);
      canvas.drawLine(
        Offset(startX - 40, y),
        Offset(startX, y),
        paint,
      );
    }
    
    // Puntos de verificación simulando tareas completadas
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(startX - 50, startY), 5, dotPaint);
    canvas.drawCircle(Offset(startX - 50, startY + 15), 5, dotPaint);
    canvas.drawCircle(Offset(startX - 50, startY + 30), 5, dotPaint);
    canvas.drawCircle(Offset(startX - 50, startY + 45), 5, dotPaint);
    
    // Añadir marcas de verificación en algunos puntos
    final checkPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Dibujar una marca de verificación simplificada
    Path checkPath = Path();
    checkPath.moveTo(startX - 53, startY);
    checkPath.lineTo(startX - 50, startY + 3);
    checkPath.lineTo(startX - 47, startY - 3);
    
    Path checkPath2 = Path();
    checkPath2.moveTo(startX - 53, startY + 15);
    checkPath2.lineTo(startX - 50, startY + 18);
    checkPath2.lineTo(startX - 47, startY + 12);
    
    canvas.drawPath(checkPath, checkPaint);
    canvas.drawPath(checkPath2, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
