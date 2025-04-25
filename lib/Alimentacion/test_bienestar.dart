import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class TestBienestar extends StatefulWidget {
  const TestBienestar({super.key});

  @override
  State<TestBienestar> createState() => _TestBienestarState();
}

class DatosUsuario {
  final double pesoActual;
  final double pesoDeseado;
  final double altura;
  final int edad;
  final String sexo;
  final String complexion;
  final String nivelActividad;
  final String objetivo;

  DatosUsuario({
    required this.pesoActual,
    required this.pesoDeseado,
    required this.altura,
    required this.edad,
    required this.sexo,
    required this.complexion,
    required this.nivelActividad,
    required this.objetivo,
  });

  Map<String, dynamic> toJson() {
    return {
      'pesoActual': pesoActual,
      'pesoDeseado': pesoDeseado,
      'altura': altura,
      'edad': edad,
      'sexo': sexo,
      'complexion': complexion,
      'nivelActividad': nivelActividad,
      'objetivo': objetivo,
    };
  }
}

class _TestBienestarState extends State<TestBienestar> {
  int _selectedIndex = 1; // Para el BottomNavigationBar
  bool _isLoading = false;
  String _resultadoTest = '';

  // Controladores para los campos de texto
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _pesoDeseadoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  
  // Variables para los menús desplegables
  String? _sexoSeleccionado;
  String? _complexionSeleccionada;
  String? _nivelActividadSeleccionado;
  String? _objetivoSeleccionado;

  // Opciones para los menús desplegables
  final List<String> _opcionesSexo = ['Masculino', 'Femenino', 'Prefiero no decirlo'];
  final List<String> _opcionesComplexion = ['Delgada', 'Promedio', 'Musculosa', 'Con sobrepeso'];
  final List<String> _opcionesNivelActividad = [
    'Sedentario - No hago ejercicio',
    'Ligero - 1 a 2 veces por semana',
    'Moderado - 3 a 4 veces por semana',
    'Alto - 5 o más veces por semana'
  ];
  final List<String> _opcionesObjetivo = [
    'Perder peso',
    'Mantener peso',
    'Ganar peso',
    'Mejorar hábitos alimenticios',
    'Mejorar mi salud en general'
  ];

  // Color para títulos
  final Color _colorTitulos = const Color.fromARGB(255, 58, 26, 114);
  final Color _primaryColor = const Color(0xFF9575CD);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      context.go('/modulos');
    } else if (index == 2) {
      context.go('/perfil');
    }
  }

  // Función para validar el formulario
  bool _validarFormulario() {
    // Verificar que todos los campos tengan valores
    if (_pesoController.text.isEmpty ||
        _pesoDeseadoController.text.isEmpty ||
        _alturaController.text.isEmpty ||
        _edadController.text.isEmpty ||
        _sexoSeleccionado == null ||
        _complexionSeleccionada == null ||
        _nivelActividadSeleccionado == null ||
        _objetivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    // Verificar que los valores numéricos sean válidos
    try {
      final peso = double.parse(_pesoController.text);
      final pesoDeseado = double.parse(_pesoDeseadoController.text);
      final altura = double.parse(_alturaController.text);
      final edad = int.parse(_edadController.text);
      
      if (peso <= 0 || peso > 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El peso debe estar entre 1 y 300 kg'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      
      if (pesoDeseado <= 0 || pesoDeseado > 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El peso deseado debe estar entre 1 y 300 kg'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      
      if (altura <= 0 || altura > 250) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La altura debe estar entre 1 y 250 cm'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      
      if (edad <= 0 || edad > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La edad debe estar entre 1 y 120 años'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese valores numéricos válidos'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    return true;
  }

  // Función para enviar datos a la API
  Future<void> _enviarDatosAPI() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final datosUsuario = DatosUsuario(
        pesoActual: double.parse(_pesoController.text),
        pesoDeseado: double.parse(_pesoDeseadoController.text),
        altura: double.parse(_alturaController.text),
        edad: int.parse(_edadController.text),
        sexo: _sexoSeleccionado!,
        complexion: _complexionSeleccionada!,
        nivelActividad: _nivelActividadSeleccionado!,
        objetivo: _objetivoSeleccionado!,
      );

      // URL de la API (reemplaza con tu URL real)
      const String apiUrl = 'https://api.tranquilidad.com/test-bienestar';
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosUsuario.toJson()),
      );

      if (response.statusCode == 200) {
        // Procesar respuesta exitosa
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _resultadoTest = data['meta'] ?? 'Meta personalizada generada con éxito';
          _isLoading = false;
        });
        _mostrarResultado();
      } else {
        // Manejar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}. Intente nuevamente.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // En caso de error en la conexión, generar una meta local
      setState(() {
        _resultadoTest = _generarMetaLocal();
        _isLoading = false;
      });
      _mostrarResultado();
    }
  }

  String _generarMetaLocal() {
    final double peso = double.parse(_pesoController.text);
    final double pesoDeseado = double.parse(_pesoDeseadoController.text);
    final double altura = double.parse(_alturaController.text);
    
    // Cálculo básico de IMC
    final double imc = peso / ((altura / 100) * (altura / 100));
    String meta = '';
    
    if (_objetivoSeleccionado == 'Perder peso' && peso > pesoDeseado) {
      meta = 'Tu meta es perder ${(peso - pesoDeseado).toStringAsFixed(1)} kg. Recomendamos una dieta balanceada y ejercicio regular.';
    } else if (_objetivoSeleccionado == 'Ganar peso' && peso < pesoDeseado) {
      meta = 'Tu meta es ganar ${(pesoDeseado - peso).toStringAsFixed(1)} kg. Enfócate en aumentar calorías con alimentos nutritivos.';
    } else if (_objetivoSeleccionado == 'Mantener peso') {
      meta = 'Tu meta es mantener tu peso actual de ${peso.toStringAsFixed(1)} kg. Continúa con hábitos equilibrados.';
    } else {
      meta = 'Enfócate en mejorar tus hábitos alimenticios y actividad física para una mejor salud.';
    }
    
    return meta;
  }

  void _mostrarResultado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Meta personalizada',
            style: TextStyle(
              color: _colorTitulos,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_resultadoTest),
              const SizedBox(height: 20),
              Image.asset('assets/inclued/imagen.resultadoBien.svg', height: 100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Redirigir después de cerrar el diálogo
                context.go('/inicio_alimentacion');
              },
              style: TextButton.styleFrom(
                backgroundColor: _primaryColor,
              ),
              child: const Text(
                'Continuar al inicio',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _enviarFormulario() {
    if (_validarFormulario()) {
      _enviarDatosAPI();
    }
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores
    _pesoController.dispose();
    _pesoDeseadoController.dispose();
    _alturaController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ALIMENTACION/Fondo_Test.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: _isLoading 
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'TEST DE BIENESTAR',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _colorTitulos,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      
                      // Sección 1: Datos Básicos
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: _primaryColor.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Datos Básicos del Usuario',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _colorTitulos,
                              ),
                            ),
                            const SizedBox(height: 15),
                            
                            // Peso actual
                            _buildTestContainer(
                              'Peso actual (kg)',
                              TextFormField(
                                controller: _pesoController,
                                keyboardType: TextInputType.number,
                                decoration: _buildInputDecoration('Ej. 70'),
                              ),
                            ),
                            
                            // Peso deseado
                            _buildTestContainer(
                              'Peso Deseado (kg)',
                              TextFormField(
                                controller: _pesoDeseadoController,
                                keyboardType: TextInputType.number,
                                decoration: _buildInputDecoration('Ej. 65'),
                              ),
                            ),
                            
                            // Altura
                            _buildTestContainer(
                              'Altura (cm)',
                              TextFormField(
                                controller: _alturaController,
                                keyboardType: TextInputType.number,
                                decoration: _buildInputDecoration('Ej. 170'),
                              ),
                            ),
                            
                            // Edad
                            _buildTestContainer(
                              'Edad (años)',
                              TextFormField(
                                controller: _edadController,
                                keyboardType: TextInputType.number,
                                decoration: _buildInputDecoration('Ej. 30'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Sección 2: Datos Corporales
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: _primaryColor.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Datos Corporales y Estilo de Vida',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _colorTitulos,
                              ),
                            ),
                            const SizedBox(height: 15),
                            
                            // Sexo
                            _buildTestContainer(
                              'Sexo biológico',
                              _buildDropdownField(
                                _opcionesSexo,
                                _sexoSeleccionado,
                                'Seleccione su sexo',
                                (value) {
                                  setState(() {
                                    _sexoSeleccionado = value;
                                  });
                                },
                              ),
                            ),
                            
                            // Complexión
                            _buildTestContainer(
                              'Complexión corporal',
                              _buildDropdownField(
                                _opcionesComplexion,
                                _complexionSeleccionada,
                                'Seleccione su complexión',
                                (value) {
                                  setState(() {
                                    _complexionSeleccionada = value;
                                  });
                                },
                              ),
                            ),
                            
                            // Nivel de actividad
                            _buildTestContainer(
                              'Nivel de actividad física semanal',
                              _buildDropdownField(
                                _opcionesNivelActividad,
                                _nivelActividadSeleccionado,
                                'Seleccione su nivel de actividad',
                                (value) {
                                  setState(() {
                                    _nivelActividadSeleccionado = value;
                                  });
                                },
                              ),
                            ),

                            // Objetivo de Salud
                            _buildTestContainer(
                              '¿Cuál es tu principal objetivo de salud?',
                              _buildDropdownField(
                                _opcionesObjetivo,
                                _objetivoSeleccionado,
                                'Seleccione su objetivo',
                                (value) {
                                  setState(() {
                                    _objetivoSeleccionado = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botón de enviar
                      Center(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: _enviarFormulario,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'ENVIAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Footer simple
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        color: _colorTitulos.withOpacity(0.1),
                        child: Column(
                          children: [
                            Text(
                              'Tranquilidad App',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _colorTitulos,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Copyright © 2024 Tranquilidad. Todos los derechos reservados.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: _colorTitulos,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialIcon(Icons.facebook),
                                const SizedBox(width: 15),
                                _buildSocialIcon(Icons.message),
                                const SizedBox(width: 15),
                                _buildSocialIcon(Icons.alternate_email),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: _primaryColor,
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _primaryColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF9575CD)),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF9575CD), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildDropdownField(
    List<String> options, 
    String? selectedValue,
    String hint,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9575CD)),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9575CD), width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      hint: Text(hint),
      dropdownColor: Colors.white,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTestContainer(String title, Widget formField) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _colorTitulos,
            ),
          ),
          const SizedBox(height: 8),
          formField,
        ],
      ),
    );
  }
}