import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'dart:async'; // Para el deslizamiento automático
import 'package:go_router/go_router.dart';

class mapa extends StatefulWidget {
  const mapa({super.key});

  @override
  State<mapa> createState() => _mapaState();
}

class _mapaState extends State<mapa> {
  int _selectedIndex = 1;
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    
    // Configurar el deslizamiento automático cada 5 segundos
    _autoScrollTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < 1) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel(); // Cancelar el temporizador al eliminar el widget
    super.dispose();
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
            // Imagen de fondo que ocupa todo el espacio a opacidad completa
            Image.network(
              'https://i.ibb.co/KcwMyfw1/image.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Contenido original
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 15), // Reducido de 20 a 15
            
            // Tarjetas con altura reducida
            Container(
              height: 380, // Reducido de 420 a 380
              child: PageView(
                controller: _pageController,
                children: [
                  _buildDreamMapCard(),
                  _buildBooksCard(),
                ],
              ),
            ),
            
            // Indicadores de página
            SizedBox(height: 10), // Reducido de 15 a 10
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPageIndicator(0),
                SizedBox(width: 8),
                _buildPageIndicator(1),
              ],
            ),
            
            SizedBox(height: 20), // Reducido de 30 a 20
            
            // Sección inferior mejorada con alto reducido
            _buildBottomSection(),
            
            SizedBox(height: 15), // Reducido de 20 a 15
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int pageIndex) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: _currentPage == pageIndex ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        shape: _currentPage == pageIndex ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: _currentPage == pageIndex ? BorderRadius.circular(4) : null,
        color: _currentPage == pageIndex
            ? Colors.purple.shade400
            : Colors.white.withOpacity(0.4),
      ),
    );
  }

  Widget _buildDreamMapCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagen de fondo que cubre toda la tarjeta
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              'https://th.bing.com/th?id=OIP.EMW7czRLUsco3um3E9Jz8QHaFj&w=288&h=216&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Gradiente para mejorar la visibilidad del texto
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Contenido de la tarjeta
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Espacio para empujar el contenido hacia abajo
              Expanded(flex: 2, child: SizedBox()),
              
              // Información
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mapa de sueños',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Visualiza y organiza tus metas en un mapa de sueños personalizado',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botón
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                     context.push('/iniciomapados');
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8E44AD),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(200, 50),
                    elevation: 5,
                  ),
                  child: Text(
                    'Crear Mapa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBooksCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagen de fondo que cubre toda la tarjeta
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              'https://www.bing.com/th?id=OIP.PgCk-ny7bnK9VjvXSv1R4QHaHa&w=206&h=206&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Gradiente para mejorar la visibilidad del texto
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Contenido de la tarjeta
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Espacio para empujar el contenido hacia abajo
              Expanded(flex: 2, child: SizedBox()),
              
              // Información
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Libros',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Encuentra libros inspiradores para tu crecimiento personal y desarrollo interior',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botón
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/iniciolibros');
               
                  },


                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8E44AD),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(200, 50),
                    elevation: 5,
                  ),
                  child: Text(
                    'Explorar Libros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Reducido el padding
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50, // Reducido de 60 a 50
            height: 50, // Reducido de 60 a 50
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.purple.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: Colors.purple.shade100,
              size: 25, // Reducido de 30 a 25
            ),
          ),
          SizedBox(height: 15), // Reducido de 20 a 15
          Text(
            "Comienza tu camino hacia la paz interior",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22, // Reducido de 24 a 22
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // Reducido de 14 a 10
          Text(
            "Descubre herramientas para cultivar la tranquilidad y encontrar balance en tu vida diaria. El viaje hacia la paz interior comienza con un pequeño paso.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15, // Reducido de 16 a 15
              height: 1.4, // Reducido de 1.5 a 1.4
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15), // Reducido de 20 a 15
          Container(
            width: 50, // Reducido de 60 a 50
            height: 50, // Reducido de 60 a 50
            decoration: BoxDecoration(
   
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF8E44AD).withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
           
            
          ),
        ],
      ),
    );
  }
}