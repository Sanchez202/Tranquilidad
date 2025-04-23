import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

class PodcastPlayerScreen extends StatefulWidget {
  final int podcastId;
  final String podcastTitle;
  final String podcastHost;
  final String coverUrl;
  final bool isAsset;
  final int episodeIndex;
  final List<Map<String, dynamic>> episodes;

  const PodcastPlayerScreen({
    super.key,
    required this.podcastId,
    required this.podcastTitle,
    required this.podcastHost,
    required this.coverUrl,
    required this.isAsset,
    required this.episodeIndex,
    required this.episodes,
  });

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}


class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  late int currentEpisodeIndex;
  bool isPlaying = true;
  bool isLooping = false;
  bool isShuffle = false;
  bool isFavorite = false; // Estado para botón de corazón
  
  // Para la velocidad de reproducción
  double playbackSpeed = 1.0;
  final List<double> speedOptions = [1.0, 2.0, 3.0];
  
  // Para almacenar el estado de favoritos de cada episodio
  final Map<int, bool> _favoriteEpisodes = {};
  
  // Para simular la reproducción
  double _progress = 0.0;
  Timer? _timer;  // Modificado para poder ser nulo
  String currentTime = "0:00";  // Inicializado con un valor predeterminado
  
  // Color morado para el corazón y la barra de reproducción
  final Color purpleColor = const Color(0xFF8E44AD);
  
  @override
  void initState() {
    super.initState();
    currentEpisodeIndex = widget.episodeIndex;
    
    // Verificar episodio inicial válido
    _validateEpisodeIndex();
    
    // Simulación de reproducción
    _startTimer();
    _updateCurrentTime();
  }
  
  @override
  void dispose() {
    _timer?.cancel();  // Usar el operador ?. para verificación de nulos
    super.dispose();
  }
  
  // Validar índice de episodio
  void _validateEpisodeIndex() {
    if (currentEpisodeIndex < 0 || currentEpisodeIndex >= widget.episodes.length) {
      currentEpisodeIndex = 0; // Establecer un valor predeterminado seguro
    }
  }
  
  void _startTimer() {
    // Cancelar el temporizador existente si existe
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!mounted) return;  // Verificar si el widget todavía está en el árbol
      
      setState(() {
        if (_progress < 1.0) {
          // Asegurarse de que el progreso nunca exceda 1.0
          // Ajustar la velocidad de avance según la velocidad de reproducción
          _progress = (_progress + (0.01 * playbackSpeed)).clamp(0.0, 1.0);
          _updateCurrentTime();
        } else {
          // Si el progreso es exactamente 1.0, manejar el final del episodio
          _handleEpisodeEnd();
        }
      });
    });
  }
  
  // Nuevo método para manejar el final del episodio de manera segura
  void _handleEpisodeEnd() {
    // Detener el temporizador actual
    _timer?.cancel();
    
    // Restablecer el progreso a 0.0 antes de cualquier otra acción
    _progress = 0.0;
    
    // Llamar a _onEpisodeComplete después de que _progress se haya restablecido
    _onEpisodeComplete();
  }
  
  void _updateCurrentTime() {
    try {
      // Verificar que el episodio actual existe
      if (currentEpisodeIndex < 0 || currentEpisodeIndex >= widget.episodes.length) {
        currentTime = "0:00";
        return;
      }
      
      // Extraer solo los minutos y segundos de la duración
      String fullDuration = widget.episodes[currentEpisodeIndex]['duration'] as String? ?? "0:00 min";
      
      // Manejar diferentes formatos posibles
      List<String> parts;
      if (fullDuration.contains(':')) {
        parts = fullDuration.split(':');
        int minutes = int.tryParse(parts[0]) ?? 0;
        
        // Extraer solo los dígitos de la parte de segundos
        String secondsPart = parts[1].split(' ')[0];
        int seconds = int.tryParse(secondsPart) ?? 0;
        
        int totalSeconds = (minutes * 60) + seconds;
        int currentSeconds = (totalSeconds * _progress).toInt();
        int currentMinutes = currentSeconds ~/ 60;
        int currentRemainingSeconds = currentSeconds % 60;
        
        currentTime = '$currentMinutes:${currentRemainingSeconds.toString().padLeft(2, '0')}';
      } else {
        // Si el formato es diferente, establecer un valor predeterminado
        currentTime = "0:00";
      }
    } catch (e) {
      // En caso de cualquier error, establecer un valor predeterminado
      currentTime = "0:00";
    }
  }
  
  void _onEpisodeComplete() {
    if (!mounted) return;  // Verificar si el widget todavía está en el árbol
    
    if (isLooping) {
      // Mantener el mismo episodio
      // Ya hemos restablecido _progress a 0.0 en _handleEpisodeEnd
      _startTimer();
    } else {
      // Pasar al siguiente episodio
      setState(() {
        if (currentEpisodeIndex < widget.episodes.length - 1) {
          currentEpisodeIndex++;
        } else {
          currentEpisodeIndex = 0;
        }
        
        // Actualizar el estado de favorito basado en el nuevo episodio
        _updateFavoriteState();
        
        // Iniciar reproducción después de actualizar el estado
        if (isPlaying) {
          // Pequeño delay para evitar problemas de renderizado
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _startTimer();
            }
          });
        }
      });
    }
  }
  
  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      
      if (isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }
  
  void _playPreviousEpisode() {
    // Cancelar temporizador y reiniciar progreso
    _timer?.cancel();
    
    setState(() {
      _progress = 0.0; // Asegurarse de que este valor se establece antes de actualizar la UI
      
      if (currentEpisodeIndex > 0) {
        currentEpisodeIndex--;
      } else {
        currentEpisodeIndex = widget.episodes.length - 1;
      }
      
      // Actualizar el estado de favorito basado en el nuevo episodio
      _updateFavoriteState();
      
      if (isPlaying) {
        // Pequeño delay para evitar problemas de renderizado
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _startTimer();
          }
        });
      }
    });
  }
  
  void _playNextEpisode() {
    // Cancelar temporizador y reiniciar progreso
    _timer?.cancel();
    
    setState(() {
      _progress = 0.0; // Asegurarse de que este valor se establece antes de actualizar la UI
      
      if (currentEpisodeIndex < widget.episodes.length - 1) {
        currentEpisodeIndex++;
      } else {
        currentEpisodeIndex = 0;
      }
      
      // Actualizar el estado de favorito basado en el nuevo episodio
      _updateFavoriteState();
      
      if (isPlaying) {
        // Pequeño delay para evitar problemas de renderizado
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _startTimer();
          }
        });
      }
    });
  }
  
  // Método para actualizar el estado del botón de favorito según el episodio actual
  void _updateFavoriteState() {
    // Verificar si este episodio ya está marcado como favorito
    isFavorite = _favoriteEpisodes[currentEpisodeIndex] ?? false;
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
  
  // Nuevo método para cambiar la velocidad de reproducción
  void _changePlaybackSpeed() {
    setState(() {
      // Encontrar el índice actual en la lista de opciones
      int currentIndex = speedOptions.indexOf(playbackSpeed);
      // Pasar a la siguiente velocidad o volver al inicio
      playbackSpeed = speedOptions[(currentIndex + 1) % speedOptions.length];
      
      // Reiniciar el timer para aplicar la nueva velocidad
      if (isPlaying) {
        _startTimer();
      }
    });
  }
  
  // Método para mostrar notificaciones
  void _showNotification(String message) {
    if (!mounted) return;  // Verificar si el widget todavía está en el árbol
    
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
  
  // Función para alternar favorito
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      
      // Guardar el estado de favorito para este episodio específico
      _favoriteEpisodes[currentEpisodeIndex] = isFavorite;
      
      // Mostrar notificación según el estado actual
      if (isFavorite) {
        _showNotification('${widget.episodes[currentEpisodeIndex]['title']} añadido a favoritos');
      } else {
        _showNotification('${widget.episodes[currentEpisodeIndex]['title']} eliminado de favoritos');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Validar que el índice actual es válido antes de acceder a datos
    _validateEpisodeIndex();
    
    // Verificar que hay episodios disponibles
    if (widget.episodes.isEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(),
        body: const Center(
          child: Text("No hay episodios disponibles"),
        ),
      );
    }
    
    Map<String, dynamic> currentEpisode = widget.episodes[currentEpisodeIndex];
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Cambiado a la imagen de fondo de musicoterapia
          image: DecorationImage(
            image: AssetImage('assets/MUSICOTERAPIA/fondo_musicoterapia.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Overlay ligero para mejorar legibilidad
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(102), // Añadido un overlay similar
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          // Back button and title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                  onPressed: () {
                                    // Primero cancelamos el timer para evitar errores
                                    _timer?.cancel();
                                    
                                    // Navegamos a la ruta correcta con los parámetros necesarios
                                    context.go('/podcast_listados', extra: {
                                      'podcastId': widget.podcastId,
                                      'title': widget.podcastTitle,
                                      'subtitle': widget.podcastHost,
                                      'imageUrl': widget.coverUrl,
                                      'isAsset': widget.isAsset,
                                    });
                                  },
                                ),
                                const Text(
                                  'REPRODUCIENDO PODCAST',
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
                          
                          // Podcast cover 
                          Container(
                            height: size.height * 0.35,
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                            child: Hero(
                              tag: 'podcast-cover',
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(128),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: widget.isAsset
                                    ? Image.asset(
                                        widget.coverUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        widget.coverUrl,
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Episode info with heart button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Episode title, host and favorite button
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title and host column
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentEpisode['title'] as String? ?? "Sin título",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.podcastHost,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Favorite button - Ahora morado en lugar de rosado
                                    IconButton(
                                      icon: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? purpleColor : Colors.black,
                                        size: 30,
                                      ),
                                      onPressed: _toggleFavorite,
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Progress bar and playback speed button side by side
                                Row(
                                  children: [
                                    // Progress bar - Expanded para ocupar espacio disponible
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 4,
                                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                          activeTrackColor: purpleColor,
                                          inactiveTrackColor: Colors.black.withAlpha(77),
                                          thumbColor: purpleColor,
                                          overlayColor: purpleColor.withAlpha(77),
                                        ),
                                        child: Slider(
                                          value: _progress,
                                          onChanged: (value) {
                                            setState(() {
                                              _progress = value;
                                              _updateCurrentTime();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    
                                    // Playback speed button - Ahora al lado de la barra de progreso
                                    ElevatedButton(
                                      onPressed: _changePlaybackSpeed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: purpleColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        minimumSize: const Size(40, 24), // Tamaño mínimo más pequeño
                                      ),
                                      child: Text('${playbackSpeed.toStringAsFixed(1)}x'),
                                    ),
                                  ],
                                ),
                                
                                // Time indicators
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentTime,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        currentEpisode['duration'] as String? ?? "0:00 min",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 15),
                                
                                // Controls section replacement - use a fixed Row with proper constraints
                                const SizedBox(height: 15),
                                
                                // Controls - Reorganized to match original layout
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Shuffle button
                                    SizedBox(
                                      width: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          isShuffle ? Icons.shuffle : Icons.shuffle,
                                          color: isShuffle ? Colors.black : Colors.black.withAlpha(153),
                                          size: 22,
                                        ),
                                        onPressed: _toggleShuffle,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    // Botón para retroceder 30 segundos
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.replay_30,
                                          color: Colors.black,
                                          size: 32,
                                        ),
                                        onPressed: () {
                                          // Retroceder 30 segundos
                                          setState(() {
                                            try {
                                              // Extraer la duración total en segundos
                                              String fullDuration = widget.episodes[currentEpisodeIndex]['duration'] as String? ?? "0:00 min";
                                              List<String> parts = fullDuration.split(':');
                                              int minutes = int.tryParse(parts[0]) ?? 0;
                                              int seconds = int.tryParse(parts[1].split(' ')[0]) ?? 0;
                                              int totalSeconds = (minutes * 60) + seconds;
                                              
                                              // Calcular cuánto representa 30 segundos en la barra de progreso
                                              double thirtySeconds = totalSeconds > 0 ? 30.0 / totalSeconds : 0.0;
                                              _progress = (_progress - thirtySeconds).clamp(0.0, 1.0);
                                              _updateCurrentTime();
                                            } catch (e) {
                                              // En caso de error, simplemente restar un porcentaje fijo
                                              _progress = (_progress - 0.1).clamp(0.0, 1.0);
                                              _updateCurrentTime();
                                            }
                                          });
                                        },
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    // Botón para ir al episodio anterior
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.skip_previous,
                                          color: Colors.black,
                                          size: 32,
                                        ),
                                        onPressed: _playPreviousEpisode,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    // Botón de pausa/reproducción
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        onPressed: _togglePlayPause,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    // Botón para ir al siguiente episodio
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.skip_next,
                                          color: Colors.black,
                                          size: 32,
                                        ),
                                        onPressed: _playNextEpisode,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    // Botón para avanzar 30 segundos
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.forward_30,
                                          color: Colors.black,
                                          size: 32,
                                        ),
                                        onPressed: () {
                                          // Avanzar 30 segundos
                                          setState(() {
                                            try {
                                              // Extraer la duración total en segundos
                                              String fullDuration = widget.episodes[currentEpisodeIndex]['duration'] as String? ?? "0:00 min";
                                              List<String> parts = fullDuration.split(':');
                                              int minutes = int.tryParse(parts[0]) ?? 0;
                                              int seconds = int.tryParse(parts[1].split(' ')[0]) ?? 0;
                                              int totalSeconds = (minutes * 60) + seconds;
                                              
                                              // Calcular cuánto representa 30 segundos en la barra de progreso
                                              double thirtySeconds = totalSeconds > 0 ? 30.0 / totalSeconds : 0.0;
                                              _progress = (_progress + thirtySeconds).clamp(0.0, 1.0);
                                              _updateCurrentTime();
                                            } catch (e) {
                                              // En caso de error, simplemente sumar un porcentaje fijo
                                              _progress = (_progress + 0.1).clamp(0.0, 1.0);
                                              _updateCurrentTime();
                                            }
                                          });
                                        },
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    // Loop button
                                    SizedBox(
                                      width: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          isLooping ? Icons.repeat_one : Icons.repeat,
                                          color: isLooping ? Colors.black : Colors.black.withAlpha(153),
                                          size: 22,
                                        ),
                                        onPressed: _toggleLooping,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Episode description - Ahora transparente en lugar de blanco
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    // Eliminado el color de fondo blanco
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.white30), // Borde sutil para delimitar
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Descripción del episodio:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currentEpisode['description'] as String? ?? 'Sin descripción disponible',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Espacio al final para evitar cortes
                                const SizedBox(height: 20),
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
      ),
    );
  }
}