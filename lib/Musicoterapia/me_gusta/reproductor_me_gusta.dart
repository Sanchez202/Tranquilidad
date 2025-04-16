import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class ReproductorMeGustaScreen extends StatefulWidget {
  final int trackIndex;
  final List<Map<String, dynamic>> tracks;

  const ReproductorMeGustaScreen({
    Key? key,
    required this.trackIndex,
    required this.tracks,
  }) : super(key: key);

  @override
  State<ReproductorMeGustaScreen> createState() => _ReproductorMeGustaScreenState();
}

class _ReproductorMeGustaScreenState extends State<ReproductorMeGustaScreen> {
  late int currentTrackIndex;
  late List<Map<String, dynamic>> tracks;
  
  bool isPlaying = true;
  bool isLooping = false;
  bool isShuffle = false;
  bool isFavorite = false;
  
  // Para mantener el estado de favoritos para cada pista
  final Map<int, bool> _favoriteTracks = {};
  
  // Para simular la reproducción con mayor precisión
  double _progress = 0.0;
  late Timer _timer;
  late String currentTime;
  
  // Color morado para el corazón y la barra de reproducción
  final Color purpleColor = const Color(0xFF8E44AD);
  
  @override
  void initState() {
    super.initState();
    
    // Extraer datos
    currentTrackIndex = widget.trackIndex;
    tracks = widget.tracks;
    
    // Inicializar el estado de favorito para la pista actual
    _updateFavoriteState();
    
    // Iniciar la simulación de reproducción con timer
    _startTimer();
    _updateCurrentTime();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) {
        setState(() {
          if (_progress < 1.0 && isPlaying) {
            _progress += 0.01;
            _updateCurrentTime();
          } else if (_progress >= 1.0) {
            _onTrackComplete();
          }
        });
      }
    });
  }
  
  void _updateCurrentTime() {
    // Extraer solo los minutos y segundos de la duración
    String fullDuration = tracks[currentTrackIndex]['duration'] as String;
    List<String> parts = fullDuration.split(':');
    int totalSeconds = int.parse(parts[0]) * 60;
    if (parts.length > 1) {
      totalSeconds += int.parse(parts[1].split(' ').first);
    }
    
    int currentSeconds = (totalSeconds * _progress).floor();
    int minutes = currentSeconds ~/ 60;
    int seconds = currentSeconds % 60;
    
    currentTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  
  void _onTrackComplete() {
    _progress = 0.0;
    
    if (isLooping) {
      // Mantener la misma pista
      _startTimer();
    } else {
      // Pasar a la siguiente pista
      _playNextTrack();
    }
  }
  
  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }
  
  void _playPreviousTrack() {
    setState(() {
      _progress = 0.0;
      _timer.cancel();
      
      if (currentTrackIndex > 0) {
        currentTrackIndex--;
      } else {
        currentTrackIndex = tracks.length - 1;
      }
      
      // Actualizar el estado de favorito para la nueva pista
      _updateFavoriteState();
      
      _updateCurrentTime();
      if (isPlaying) {
        _startTimer();
      }
    });
  }
  
  void _playNextTrack() {
    setState(() {
      _progress = 0.0;
      _timer.cancel();
      
      if (currentTrackIndex < tracks.length - 1) {
        currentTrackIndex++;
      } else {
        currentTrackIndex = 0;
      }
      
      // Actualizar el estado de favorito para la nueva pista
      _updateFavoriteState();
      
      _updateCurrentTime();
      if (isPlaying) {
        _startTimer();
      }
    });
  }
  
  // Método para actualizar el estado del botón de favorito según la pista actual
  void _updateFavoriteState() {
    // Verificar si esta pista ya está marcada como favorita
    isFavorite = _favoriteTracks[currentTrackIndex] ?? false;
  }
  
  void _toggleLooping() {
    setState(() {
      isLooping = !isLooping;
    });
  }
  
  void _toggleShuffle() {
    setState(() {
      isShuffle = !isShuffle;
    });
  }
  
  // Método para mostrar notificaciones
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9575CD),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
  
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      
      // Guardar el estado de favorito para esta pista específica
      _favoriteTracks[currentTrackIndex] = isFavorite;
      
      // Mostrar notificación según el estado actual
      if (isFavorite) {
        _showNotification('${tracks[currentTrackIndex]['title']} añadido a favoritos');
      } else {
        _showNotification('${tracks[currentTrackIndex]['title']} eliminado de favoritos');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentTrack = tracks[currentTrackIndex];
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/MUSICOTERAPIA/fondo_musicoterapia.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        // Back button and title - USANDO GO ROUTER PARA VOLVER A ME GUSTA SCREEN
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                onPressed: () => context.go('/musicoterapia/me_gusta'),
                              ),
                              const Text(
                                'REPRODUCIENDO AHORA',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Espacio para mantener centrado el título
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                        
                        // Album cover más grande (35% de la altura de la pantalla)
                        Container(
                          height: size.height * 0.35,
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                          child: Hero(
                            tag: 'player-cover-${currentTrack['number']}',
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: currentTrack.containsKey('image') && currentTrack['image'] != null
                                  ? Image.asset(
                                      currentTrack['image'],
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey,
                                      child: Center(
                                        child: Text(
                                          '${currentTrack['number']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Sección inferior - Información de pista y controles
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título y botón de favorito
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and artist column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentTrack['title'] ?? 'Weightless',
                                          style: const TextStyle(
                                            color: Colors.black,  // Negro para el título
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Lo mejor de la música clásica',  // Subtítulo fijo
                                          style: const TextStyle(
                                            color: Colors.black,  // Negro para el subtítulo 
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Botón de favorito en negro cuando no está activado
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? purpleColor : Colors.black,  // Negro cuando no está activado
                                      size: 30,
                                    ),
                                    onPressed: _toggleFavorite,
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Slider con color morado
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                  activeTrackColor: purpleColor,
                                  inactiveTrackColor: Colors.grey.shade300,
                                  thumbColor: purpleColor,
                                  overlayColor: purpleColor.withOpacity(0.3),
                                ),
                                child: Slider(
                                  value: _progress,
                                  min: 0,
                                  max: 1,
                                  onChanged: (double value) {
                                    setState(() {
                                      _progress = value;
                                      _updateCurrentTime();
                                    });
                                  },
                                ),
                              ),
                              
                              // Duración
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      currentTime,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      currentTrack['duration'] ?? '3:30',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Controles con mejor espaciado
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.shuffle,
                                      color: isShuffle ? Colors.black : Colors.black.withOpacity(0.6),
                                      size: 22,
                                    ),
                                    onPressed: _toggleShuffle,
                                    constraints: const BoxConstraints(),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      color: Colors.black87,
                                      size: 35,
                                    ),
                                    onPressed: _playPreviousTrack,
                                  ),
                                  // Botón de reproducción negro como en la imagen
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      onPressed: _togglePlayPause,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.skip_next,
                                      color: Colors.black87,
                                      size: 35,
                                    ),
                                    onPressed: _playNextTrack,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      isLooping ? Icons.repeat_one : Icons.repeat,
                                      color: isLooping ? Colors.black : Colors.black.withOpacity(0.6),
                                      size: 22,
                                    ),
                                    onPressed: _toggleLooping,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    // Detener el timer cuando se destruye el widget
    _timer.cancel();
    super.dispose();
  }
}