import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class VideoPodcast extends StatefulWidget {
  const VideoPodcast({super.key});

  @override
  State<VideoPodcast> createState() => _VideoPodcastState();
}

class _VideoPodcastState extends State<VideoPodcast> with SingleTickerProviderStateMixin {
  int _selectedIndex = 1; // Mantiene el índice de navegación en 1 (Musicoterapia)
  final List<String> _tabs = ['GENEROS', 'ÁLBUMS', 'PODCAST', 'SONIDOS BINAURALES', 'PLAYLIST', 'ME GUSTA'];
  
  // Recording type tabs
  final List<String> _recordingTypeTabs = ['AUDIO', 'VIDEO'];
  final int _selectedRecordingTypeIndex = 1;
  
  // Estado de simulación de grabación
  bool _isRecording = false;
  bool _isPaused = false;

  // Controlador para la animación de la cámara
  late AnimationController _cameraFillController;
  late Animation<double> _cameraFillAnimation;

  // Variables para el contador de tiempo de grabación
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String _formattedTime = "00:00";
  
  // Text controller for recording name
  final TextEditingController _recordingNameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();

    // Inicializar controlador de animación
    _cameraFillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Crear animación que va de 0 a 1
    _cameraFillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_cameraFillController);
  }

  @override
  void dispose() {
    _cameraFillController.dispose();
    _recordingTimer?.cancel();
    _recordingNameController.dispose();
    super.dispose();
  }
  
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

  void _onTabSelected(int index) {
    // Navegar a la vista correspondiente según la pestaña seleccionada
    switch (index) {
      case 0: // GENEROS
        context.go('/musicoterapia');
        break;
      case 1: // ALBUMS
        context.go('/musicoterapia/albums');
        break;
      case 2: // PODCAST
        context.go('/musicoterapia/podcast');
        break;
      case 3: // SONIDOS BINAURALES
        context.go('/musicoterapia/sonidos_binaurales');
        break;
      case 4: // PLAYLIST
        context.go('/musicoterapia/playlist');
        break;
      case 5: // ME GUSTA
        context.go('/musicoterapia/me_gusta');
        break;
    }
  }

  void _onRecordingTypeTabSelected(int index) {
    if (index == 0) { // AUDIO selected
      // Navigate to audio podcast screen
      context.go('/musicoterapia/podcast/grabar_podcast');
    }
    // No need to handle video tab selection as we're already on the video screen
  }

  // Método para simular inicio de grabación
  void _startRecording() {
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _recordingSeconds = 0;
      _formattedTime = "00:00";
    });

    // Start continuous camera animation
    _cameraFillController.repeat(reverse: true);

    // Start time counter
    _startTimer();
  }

  // Método para simular pausar la grabación
  void _pauseRecording() {
    if (!_isPaused) {
      // Pausar la animación
      _cameraFillController.stop();
      // Pausar el contador de tiempo
      _pauseTimer();

      setState(() {
        _isPaused = true;
      });
    } else {
      // Reanudar la animación
      _cameraFillController.repeat(reverse: true);
      // Reanudar el contador de tiempo
      _startTimer();

      setState(() {
        _isPaused = false;
      });
    }
  }

  // Método para simular detener la grabación y mostrar diálogo
  void _stopRecording() {
    // Detener la animación y resetear
    _cameraFillController.reset();

    // Detener el contador de tiempo
    _pauseTimer();

    setState(() {
      _isRecording = false;
      _isPaused = false;
    });

    // Mostrar el diálogo para nombrar la grabación
    _showNameRecordingDialog();
  }

  // Nuevo método para mostrar el diálogo de nombrar grabación
// Método modificado para mostrar el diálogo de nombrar grabación
void _showNameRecordingDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Guardar grabación',
          style: TextStyle(
            color: Color(0xFF9575CD),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _recordingNameController,
          decoration: const InputDecoration(
            hintText: 'Nombre de la grabación',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF9575CD)),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              _recordingNameController.clear();
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9575CD),
            ),
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // Cerrar el diálogo
              Navigator.of(context).pop();
              
              // Mostrar notificación de éxito
              _showSuccessNotification();
              
              // Limpiar el controlador de texto
              _recordingNameController.clear();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      );
    },
  );
}

// También hay que modificar el método _showSuccessNotification para hacerlo igual
void _showSuccessNotification() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 10),
          Text('¡Grabación guardada con éxito!'),
        ],
      ),
      backgroundColor: const Color(0xFF9575CD),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.1,
        left: 20,
        right: 20,
      ),
    ),
  );
}

  // Iniciar el temporizador
  void _startTimer() {
    // Cancelar cualquier timer existente
    _recordingTimer?.cancel();

    // Crear un nuevo timer que se ejecuta cada segundo
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
        _formattedTime = _formatTime(_recordingSeconds);
      });
    });
  }

  // Pausar el temporizador
  void _pauseTimer() {
    _recordingTimer?.cancel();
  }

  // Formatear el tiempo en minutos:segundos
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Add MediaQuery padding to handle safe areas
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/MUSICOTERAPIA/fondo_musicoterapia.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light overlay for better readability
          Container(color: const Color.fromARGB(255, 209, 187, 224).withAlpha(179)),
          
          // Main content
          SafeArea(
            // Use SafeArea to respect device insets
            bottom: false, // We'll handle bottom padding manually
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'ESTUDIO PODCAST',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Tab Bar - mantiene el menú horizontal pero ninguno está seleccionado
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(_tabs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: GestureDetector(
                            onTap: () => _onTabSelected(index),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _tabs[index],
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0), // Todos en gris, ninguno seleccionado
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // New Audio/Video tab bar - styled like the main tab bar
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_recordingTypeTabs.length, (index) {
                      bool isSelected = index == _selectedRecordingTypeIndex;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () => _onRecordingTypeTabSelected(index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _recordingTypeTabs[index],
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFF9575CD) : Colors.grey,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Indicator line for selected tab
                              Container(
                                height: 3,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF9575CD) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                
                // Contenido principal de la vista Estudio de Video
                Expanded(
                  child: SingleChildScrollView(  // Add scrolling capability
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding + 52), // Add extra bottom padding to avoid overflow
                      child: _buildEstudioVideoContent(screenWidth),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: const Color(0xFF9575CD),
      ),
    );
  }

  Widget _buildEstudioVideoContent(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          
          // Icono de cámara con animación interna (reemplazando el recuadro negro)
          AnimatedBuilder(
            animation: _cameraFillAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Contorno de la cámara (siempre visible)
                  const Icon(
                    Icons.videocam_outlined,
                    size: 100,
                    color: Color(0xFF9575CD),
                  ),

                  // Cámara rellena que se anima
                  if (_isRecording)
                    Opacity(
                      opacity: _cameraFillAnimation.value,
                      child: const Icon(
                        Icons.videocam,
                        size: 100,
                        color: Color(0xFF9575CD),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 15),

          // Mostrar el contador de tiempo solo cuando está grabando
          if (_isRecording)
            Text(
              _formattedTime,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9575CD),
              ),
            ),
          
          const SizedBox(height: 30),
          
          // Botones de control de grabación
          if (!_isRecording)
            // Botón para comenzar a grabar
            ElevatedButton.icon(
              icon: const Icon(Icons.videocam, color: Colors.white),
              label: const Text(
                'COMENZAR A GRABAR',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9575CD),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _startRecording,
            )
          else
            // Botones de control cuando está "grabando" (horizontalmente y más pequeños)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
              ), // 10% de padding horizontal
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón para pausar/reanudar grabación (más pequeño)
                  SizedBox(
                    width: screenWidth * 0.35, // 35% del ancho de pantalla
                    child: ElevatedButton.icon(
                      icon: Icon(
                        _isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                        size: 20, // Ícono más pequeño
                      ),
                      label: Text(
                        _isPaused ? 'REANUDAR' : 'PAUSAR',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12, // Texto más pequeño
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9575CD),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _pauseRecording,
                    ),
                  ),

                  SizedBox(
                    width: screenWidth * 0.1,
                  ), // 10% de espacio entre botones
                  // Botón para detener grabación (más pequeño)
                  SizedBox(
                    width: screenWidth * 0.35, // 35% del ancho de pantalla
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 20, // Ícono más pequeño
                      ),
                      label: const Text(
                        'DETENER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12, // Texto más pequeño
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _stopRecording,
                    ),
                  ),
                ],
              ),
            ),
            
          const SizedBox(height: 20),
          
          // Se eliminó el botón "Ver mis grabaciones" para evitar errores
          
          const SizedBox(height: 20),
          // Información adicional sobre grabación de video
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(77),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: const [
                Text(
                  'Consejos para grabar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9575CD),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Busca un lugar tranquilo y bien iluminado\n'
                  '• Utiliza un trípode o soporte para estabilizar\n'
                  '• Asegúrate de tener suficiente batería\n'
                  '• Comprueba el espacio disponible en tu dispositivo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}