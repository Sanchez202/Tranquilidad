import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final double proteinas;
  final double grasas;
  final double carbohidratos;

  DatosUsuario({
    required this.pesoActual,
    required this.pesoDeseado,
    required this.proteinas,
    required this.grasas,
    required this.carbohidratos,
  });
}


class _TestBienestarState extends State<TestBienestar> {
  int _selectedIndex = 1; // Para el BottomNavigationBar

  // Controladores para los campos de texto
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _pesoDeseadoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  
  // Variables para los menús desplegables
  String? _sexoSeleccionado;
  String? _complexionSeleccionada;
  String? _nivelActividadSeleccionado;

  // Opciones para los menús desplegables
  final List<String> _opcionesSexo = ['Masculino', 'Femenino'];
  final List<String> _opcionesComplexion = ['Delgada', 'Media', 'Robusta'];
  final List<String> _opcionesNivelActividad = ['Bajo', 'Moderado', 'Alto'];

  // Color para títulos (mismo que "Datos básicos del usuario")
  final Color _colorTitulos = const Color.fromARGB(255, 58, 26, 114);

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

  // Función para validar el formulario
  bool _validarFormulario() {
    // Verificar que todos los campos tengan valores
    if (_pesoController.text.isEmpty ||
        _alturaController.text.isEmpty ||
        _edadController.text.isEmpty ||
        _sexoSeleccionado == null ||
        _complexionSeleccionada == null ||
        _nivelActividadSeleccionado == null) {
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

  void _enviarFormulario() {
    if (_validarFormulario()) {
      // Aquí se procesarían los datos y se enviarían al backend o se guardarían localmente
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Información enviada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navegar a la pantalla de inicio_alimentacion después de un breve retraso
      // para permitir que se muestre la notificación
      Future.delayed(const Duration(seconds: 2), () {
        context.go('/inicio_alimentacion');
      });
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
            child: SingleChildScrollView(
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
                  const SizedBox(height: 10),
                  


                  // Contenedor 1: Peso actual
                  _buildTestContainer(
                    'Peso actual (kg)',
                    TextFormField(
                      controller: _pesoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ej. 70',
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
                      ),
                    ),
                  ),

                    // Contenedor: Peso Deseado
                  _buildTestContainer(
                    'Peso Deseado (kg)',
                    TextFormField(
                      controller: _pesoDeseadoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '(Kg)',
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
                      ),
                    ),
                  ),


                  // Contenedor 2: Altura
                  _buildTestContainer(
                    'Altura (cm)',
                    TextFormField(
                      controller: _alturaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '(Cm)',
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
                      ),
                    ),
                  ),

                  // Contenedor 3: Edad
                  _buildTestContainer(
                    'Edad',
                    TextFormField(
                      controller: _edadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Años',
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
                      ),
                    ),
                  ),

                  // Contenedor 4: Sexo (Menú desplegable)
                  _buildTestContainer(
                    'Sexo',
                    DropdownButtonFormField<String>(
                      value: _sexoSeleccionado,
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
                      hint: const Text('Seleccione su sexo'),
                      dropdownColor: Colors.white,
                      items: _opcionesSexo.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _sexoSeleccionado = newValue;
                        });
                      },
                    ),
                  ),

                  // Contenedor 5: Complexión (Menú desplegable)
                  _buildTestContainer(
                    'Complexión',
                    DropdownButtonFormField<String>(
                      value: _complexionSeleccionada,
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
                      hint: const Text('Seleccione su complexión'),
                      dropdownColor: Colors.white,
                      items: _opcionesComplexion.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _complexionSeleccionada = newValue;
                        });
                      },
                    ),
                  ),

                  // Contenedor 6: Nivel de actividad (Menú desplegable)
                  _buildTestContainer(
                    'Nivel de actividad',
                    DropdownButtonFormField<String>(
                      value: _nivelActividadSeleccionado,
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
                      hint: const Text('Seleccione su nivel de actividad'),
                      dropdownColor: Colors.white,
                      items: _opcionesNivelActividad.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _nivelActividadSeleccionado = newValue;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botón de enviar (más pequeño)
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _enviarFormulario,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9575CD),
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
                ],
              ),
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

  

  Widget _buildTestContainer(String title, Widget formField) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Reducido de 20 a 12
      padding: const EdgeInsets.all(12), // Reducido de 16 a 12
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15), // Aumentado de 10 a 15
      ),
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
          const SizedBox(height: 8), // Reducido de 10 a 8
          formField,
        ],
      ),
    );
  }
}