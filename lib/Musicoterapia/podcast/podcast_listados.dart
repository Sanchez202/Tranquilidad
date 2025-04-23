import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';

class PodcastListadosScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isAsset;
  final int podcastId;

  const PodcastListadosScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isAsset,
    required this.podcastId,
  });

  @override
  State<PodcastListadosScreen> createState() => _PodcastListadosScreenState();
}

class _PodcastListadosScreenState extends State<PodcastListadosScreen> {
  bool isFavorite = false;
  late List<Map<String, String>> podcastList;
  // Lista para mantener el estado de favorito de cada podcast
  late List<bool> podcastFavorites;

  @override
  void initState() {
    super.initState();
    podcastList = _getPodcastsForCategory(widget.podcastId);
    // Inicializar la lista de favoritos para cada podcast
    podcastFavorites = List.generate(podcastList.length, (index) => false);
  }

  // Método para obtener podcasts específicos según el ID de la categoría con nombres customizados
  List<Map<String, String>> _getPodcastsForCategory(int podcastId) {
    switch (podcastId) {
      case 1: // Afirmaciones
        return [
          {'title': 'Afirmaciones Diarias', 'duration': '12:30'},
          {'title': 'Afirmaciones para el Éxito', 'duration': '15:45'},
          {'title': 'Afirmaciones de Autoconfianza', 'duration': '10:12'},
          {'title': 'Afirmaciones para Ansiedad', 'duration': '18:55'},
          {'title': 'Afirmaciones de Gratitud', 'duration': '14:20'},
          {'title': 'Afirmaciones para Dormir', 'duration': '23:15'},
          {'title': 'Afirmaciones para el Trabajo', 'duration': '16:04'},
          {'title': 'Afirmaciones de Abundancia', 'duration': '19:48'},
        ];
      case 2: // Autoestima
        return [
          {'title': 'Construye tu Autoestima', 'duration': '25:30'},
          {'title': 'Amor Propio', 'duration': '18:15'},
          {'title': 'Desafía tus Creencias Limitantes', 'duration': '22:22'},
          {'title': 'Confianza en ti mismo', 'duration': '20:48'},
          {'title': 'Supera la Autocrítica', 'duration': '15:10'},
          {'title': 'Aprendiendo a Quererte', 'duration': '24:35'},
          {'title': 'Aceptación Personal', 'duration': '21:25'},
          {'title': 'Autoestima y Relaciones', 'duration': '19:59'},
        ];
      case 3: // Meditación
        return [
          {
            'title': 'Meditación Guiada para Principiantes',
            'duration': '14:42',
          },
          {'title': 'Meditación para Ansiedad', 'duration': '19:18'},
          {'title': 'Meditación para Dormir', 'duration': '25:56'},
          {'title': 'Meditación de Atención Plena', 'duration': '16:10'},
          {'title': 'Meditación para Reducir Estrés', 'duration': '22:30'},
          {'title': 'Meditación para Concentración', 'duration': '15:05'},
          {'title': 'Meditación de Gratitud', 'duration': '18:22'},
          {'title': 'Meditación para Energía', 'duration': '13:48'},
        ];
      case 4: // Nuestro estudio
        return [
          {
            'title': 'Introducción a la Creación de Podcast',
            'duration': '24:15',
          },
          {'title': 'Equipo Básico para Podcast', 'duration': '19:22'},
          {'title': 'Cómo Grabar tu Voz', 'duration': '16:50'},
          {'title': 'Técnicas de Edición', 'duration': '22:38'},
          {'title': 'Música y Efectos de Sonido', 'duration': '20:12'},
          {'title': 'Distribución de tu Podcast', 'duration': '18:30'},
          {'title': 'Monetización de Podcast', 'duration': '25:45'},
          {'title': 'Estrategias de Marketing', 'duration': '21:58'},
        ];
      case 5: // Sonidos Relajantes
        return [
          {'title': 'Lluvia en el Bosque', 'duration': '18:20'},
          {'title': 'Olas del Mar', 'duration': '22:15'},
          {'title': 'Sonidos de la Naturaleza', 'duration': '25:30'},
          {'title': 'Tormenta Tranquila', 'duration': '19:45'},
          {'title': 'Pájaros del Amanecer', 'duration': '16:10'},
          {'title': 'Cascada Serena', 'duration': '21:05'},
          {'title': 'Fuego de Campamento', 'duration': '17:40'},
          {'title': 'Noche Estrellada', 'duration': '24:15'},
        ];
      case 6: // Historias para Dormir
        return [
          {'title': 'El Jardín Secreto', 'duration': '26:30'},
          {'title': 'Viaje a las Estrellas', 'duration': '19:45'},
          {'title': 'El Bosque Encantado', 'duration': '22:20'},
          {'title': 'La Playa de los Sueños', 'duration': '18:35'},
          {'title': 'Aventura en las Nubes', 'duration': '23:10'},
          {'title': 'La Montaña Mágica', 'duration': '20:55'},
          {'title': 'El Barco de la Calma', 'duration': '21:40'},
          {'title': 'La Cueva de Cristal', 'duration': '24:05'},
        ];
      case 7: // Música Terapéutica
        return [
          {'title': 'Melodías para Sanar', 'duration': '25:15'},
          {'title': 'Armonía Interior', 'duration': '18:40'},
          {'title': 'Ritmos del Corazón', 'duration': '22:35'},
          {'title': 'Frecuencias Curativas', 'duration': '20:25'},
          {'title': 'Vibraciones Positivas', 'duration': '19:50'},
          {'title': 'Sonidos del Alma', 'duration': '23:30'},
          {'title': 'Resonancia Sanadora', 'duration': '21:20'},
          {'title': 'Equilibrio Sonoro', 'duration': '24:45'},
        ];
      case 8: // Mindfulness
        return [
          {'title': 'Introducción al Mindfulness', 'duration': '16:20'},
          {'title': 'Atención Plena Diaria', 'duration': '18:45'},
          {'title': 'Respiración Consciente', 'duration': '14:30'},
          {'title': 'Caminata Mindfulness', 'duration': '17:15'},
          {'title': 'Mindfulness y Emociones', 'duration': '20:40'},
          {'title': 'Prácticas de Compasión', 'duration': '19:25'},
          {'title': 'Comer con Atención Plena', 'duration': '15:50'},
          {'title': 'Mindfulness en el Trabajo', 'duration': '22:10'},
        ];
      default:
        // Para casos adicionales
        return [
          {'title': 'Descubriendo la Calma', 'duration': '16:15'},
          {'title': 'Momentos de Paz', 'duration': '17:22'},
          {'title': 'Equilibrio Emocional', 'duration': '18:50'},
          {'title': 'Senderos de Tranquilidad', 'duration': '14:10'},
          {'title': 'Universo Interior', 'duration': '13:40'},
          {'title': 'Respira y Relájate', 'duration': '15:30'},
          {'title': 'Espacio para Ser', 'duration': '19:45'},
          {'title': 'Bienestar Consciente', 'duration': '13:55'},
        ];
    }
  }

  // Método para mostrar notificaciones con Snackbar
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
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

  // Método modificado para navegar al reproductor de podcast
  void _navigateToPlayer(String title, String duration) {
    // Crear una descripción por defecto para cada episodio
    String description =
        'Este es un episodio de ${widget.title} que te ayudará a relajarte y a mejorar tu bienestar emocional. Escucha con atención y disfruta de la experiencia.';

    // Crear la lista de episodios con el formato correcto
    List<Map<String, dynamic>> episodes =
        podcastList.map((podcast) {
          return {
            'title': podcast['title'],
            'duration': podcast['duration'],
            'description': description,
          };
        }).toList();

    // Encontrar el índice del episodio seleccionado
    int episodeIndex = podcastList.indexWhere(
      (podcast) => podcast['title'] == title,
    );
    if (episodeIndex == -1) episodeIndex = 0;

    // Navegar al reproductor de podcast
    context.go(
      '/musicoterapia/podcast/reproductor_podcast',
      extra: {
        'podcastId': widget.podcastId,
        'podcastTitle': widget.title,
        'podcastHost':
            'Reading Time', // Usar el mismo host que se muestra en la UI
        'coverUrl': widget.imageUrl,
        'isAsset': widget.isAsset,
        'episodeIndex': episodeIndex,
        'episodes': episodes,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(), // Mantiene el AppBar original
      body: Stack(
        children: [
          // Mantiene el fondo original
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/MUSICOTERAPIA/fondo_musicoterapia.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 209, 187, 224).withAlpha(179),
          ),

          // Contenido
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón de retroceso - Lleva a podcast_screen.dart
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => context.go('/musicoterapia/podcast'),
                    ),
                  ),
                  // Imagen y detalles del podcast
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'podcast-${widget.podcastId}',
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(77),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  widget.isAsset
                                      ? Image.asset(
                                        widget.imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.network(
                                        widget.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Por: Reading Time',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.podcasts,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${podcastList.length} episodios',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botones de acción
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        // Botón reproducir
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9575CD),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // Navegar al reproductor con el primer podcast
                              _navigateToPlayer(
                                podcastList[0]['title']!,
                                podcastList[0]['duration']!,
                              );
                            },
                            child: const Text(
                              'REPRODUCIR',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Botón favorito
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(77),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isFavorite
                                      ? const Color(0xFF9575CD)
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              _showNotification(
                                isFavorite
                                    ? 'Añadido a Tus Me Gusta'
                                    : 'Eliminado de Tus Me Gusta',
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Botón compartir
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(77),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _showNotification(
                                'Compartiendo: ${widget.title}',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Título de la sección de episodios
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Episodios',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Lista de episodios
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: podcastList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        // Miniatura del podcast
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child:
                                widget.isAsset
                                    ? Image.asset(
                                      widget.imageUrl,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.network(
                                      widget.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                        title: Text(
                          podcastList[index]['title']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Duración: ${podcastList[index]['duration']}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        // Botones de acción a la derecha
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Corazón favorito para cada episodio
                            IconButton(
                              icon: Icon(
                                podcastFavorites[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    podcastFavorites[index]
                                        ? const Color(0xFF9575CD)
                                        : Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  podcastFavorites[index] =
                                      !podcastFavorites[index];
                                });
                                _showNotification(
                                  '"${podcastList[index]['title']}" ${podcastFavorites[index] ? 'añadido a Tus Me Gusta' : 'eliminado de Tus Me Gusta'}',
                                );
                              },
                            ),
                            // Botón de reproducción estilizado
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                padding: EdgeInsets.zero,
                                iconSize: 18,
                                onPressed: () {
                                  // Navegar al reproductor con el podcast seleccionado
                                  _navigateToPlayer(
                                    podcastList[index]['title']!,
                                    podcastList[index]['duration']!,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navegar al reproductor con el podcast seleccionado
                          _navigateToPlayer(
                            podcastList[index]['title']!,
                            podcastList[index]['duration']!,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
