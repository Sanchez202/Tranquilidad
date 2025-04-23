import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class BibliotecaPodcast extends StatefulWidget {
  const BibliotecaPodcast({super.key});

  @override
  State<BibliotecaPodcast> createState() => _BibliotecaPodcastState();
}

class _BibliotecaPodcastState extends State<BibliotecaPodcast> {
  int _selectedIndex = 1; // Mantiene el índice de navegación en 1 (Musicoterapia)
  final List<String> _tabs = [
    'GENEROS',
    'ÁLBUMS',
    'PODCAST',
    'SONIDOS BINAURALES',
    'PLAYLIST',
    'ME GUSTA',
  ];

  // Las pestañas para los tipos de grabaciones
  final List<String> _podcastTabs = ['Todos', 'Audio', 'Video'];
  int _selectedPodcastTab = 0;

  // Lista de grabaciones simulada (solo para mostrar UI)
late final bool _isLoading;
late final List<Map<String, dynamic>> _recordings;


  // Orden seleccionado
  String _selectedOrder = 'Recientes';

  @override
  void initState() {
    super.initState();
    // Simulamos algunas grabaciones para mostrar la interfaz
    _simulateRecordings();
  }

  void _simulateRecordings() {
    // Creamos grabaciones simuladas para mostrar la interfaz
    _recordings = [];
    
    if (_selectedPodcastTab == 0 || _selectedPodcastTab == 1) {
      _recordings.add({
        'id': '1',
        'name': 'Meditación guiada',
        'type': 'audio',
        'duration': '05:30',
        'date': '25/04/2025',
      });
      
      _recordings.add({
        'id': '2',
        'name': 'Ejercicio de relajación',
        'type': 'audio',
        'duration': '08:45',
        'date': '20/04/2025',
      });
    }
    
    if (_selectedPodcastTab == 0 || _selectedPodcastTab == 2) {
      _recordings.add({
        'id': '3',
        'name': 'Tutorial de yoga',
        'type': 'video',
        'duration': '12:20',
        'date': '22/04/2025',
      });
    }
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

  void _onPodcastTabSelected(int index) {
    if (index != _selectedPodcastTab) {
      setState(() {
        _selectedPodcastTab = index;
        _recordings = []; // Limpiar grabaciones actuales
        _simulateRecordings(); // Simular nuevas grabaciones según la pestaña
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add MediaQuery padding to handle safe areas
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Background image - se mantiene igual
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
                  'MIS GRABACIONES',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Tab Bar - se mantiene el menú horizontal igual
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

                // Contenido principal de la vista Mis Grabaciones
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: bottomPadding + 52,
                      ), // Add extra bottom padding to avoid overflow
                      child: _buildMisGrabacionesContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9575CD),
        onPressed: () {
          // Navegar al estudio de podcast para grabar
          context.go('/musicoterapia/podcast/grabar_podcast');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: const Color(0xFF9575CD),
      ),
    );
  }

  Widget _buildMisGrabacionesContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pestañas para filtrar por tipo de podcast
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: List.generate(_podcastTabs.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onPodcastTabSelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedPodcastTab == index
                            ? const Color(0xFF9575CD)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _podcastTabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedPodcastTab == index
                              ? Colors.white
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 25),

          // Opciones de ordenación
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Ordenar por: ',
                style: TextStyle(color: Colors.black54),
              ),
              DropdownButton<String>(
                value: _selectedOrder,
                underline: Container(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF9575CD),
                ),
                items: <String>[
                  'Recientes',
                  'Antiguos',
                  'Duración',
                  'Alfabético',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF9575CD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && newValue != _selectedOrder) {
                    setState(() {
                      _selectedOrder = newValue;
                    });
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Mostrar cargando si está cargando los datos
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9575CD)),
              ),
            )
          // Mostrar estado vacío si no hay grabaciones
          else if (_recordings.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    _selectedPodcastTab == 2
                        ? Icons.videocam_off
                        : Icons.mic_off,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _selectedPodcastTab == 0
                        ? 'No tienes grabaciones'
                        : _selectedPodcastTab == 1
                            ? 'No tienes grabaciones de audio'
                            : 'No tienes grabaciones de video',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Las grabaciones que realices desde el estudio de podcast se almacenarán aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      'IR AL ESTUDIO',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9575CD),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Navegar de vuelta al estudio de podcast
                      context.go('/musicoterapia/podcast/grabar_podcast');
                    },
                  ),
                ],
              ),
            )
          // Mostrar lista de grabaciones si hay datos
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recordings.length,
              itemBuilder: (context, index) {
                final recording = _recordings[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF9575CD),
                      child: Icon(
                        recording['type'] == 'audio'
                            ? Icons.mic
                            : Icons.videocam,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      recording['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          'Duración: ${recording['duration']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Fecha: ${recording['date']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón para "reproducir" (solo visual)
                        IconButton(
                          icon: const Icon(
                            Icons.play_circle_filled,
                            color: Color(0xFF9575CD),
                            size: 36,
                          ),
                          onPressed: () {
                            // No hace nada, solo para mostrar el botón
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
