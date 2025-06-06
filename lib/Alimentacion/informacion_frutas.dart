import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class InformacionFrutas extends StatefulWidget {
  const InformacionFrutas({super.key});

  @override
  State<InformacionFrutas> createState() => _InformacionFrutasState();
}

class _InformacionFrutasState extends State<InformacionFrutas> {
  int _selectedIndex = 1;
  int? _focusedCardIndex; // Para controlar qué tarjeta está enfocada/volteada

  // Lista de frutas con su información en el orden especificado
  final List<FruitInfo> _fruitList = [
    FruitInfo(
        name: 'Manzana',
        description:
            'Las manzanas son conocidas por ser una buena fuente de fibra, especialmente pectina, que puede ayudar a mantener niveles saludables de colesterol. También contienen antioxidantes como quercetina, que puede tener propiedades antiinflamatorias.',
        classification: 'Fruta pomácea, cultivada en todo el mundo y disponible en una variedad de colores y sabores.',
        averageWeight: '150-250 gramos',
        color: 'Varía entre rojo, verde y amarillo',
        commonUses: 'Consumo crudo, cocido, en jugos y compotas',
        imageUrl: 'assets/ALIMENTACION/manzana_verde.png',
      ),
      FruitInfo(
        name: 'Banano',
        description:
            'Los bananos son una excelente fuente de potasio, un mineral crucial para la función muscular y nerviosa. También contienen vitamina B6, que es importante para la salud del cerebro y la producción de hemoglobina.',
        classification: 'Fruta tropical que crece en climas cálidos y se consume ampliamente en todo el mundo.',
        averageWeight: '120-150 gramos',
        color: 'Amarillo cuando maduro',
        commonUses: 'Consumo crudo, en batidos, postres y horneados',
        imageUrl: 'assets/ALIMENTACION/banano.png',
      ),
      FruitInfo(
        name: 'Mango',
        description:
            'El mango es rico en vitaminas A y C, potasio y fibra. Contiene antioxidantes como la quercetina, el ácido fólico y el beta-caroteno, que contribuyen a una buena salud.',
        classification: 'Fruta tropical de hueso originaria del sur de Asia.',
        averageWeight: '200-300 gramos',
        color: 'Verde, amarillo, naranja o rojo según madurez',
        commonUses: 'Consumo fresco, batidos, salsas, ensaladas y postres',
        imageUrl: 'assets/ALIMENTACION/mango.png',
      ),
      FruitInfo(
        name: 'Maracuyá',
        description:
            'El maracuyá es rico en vitamina C, vitamina A y fibra. Sus semillas contienen ácidos grasos esenciales. Tiene propiedades antioxidantes y puede ayudar a reducir la ansiedad.',
        classification: 'Fruta tropical de la familia Passifloraceae.',
        averageWeight: '50-80 gramos',
        color: 'Amarillo o morado según la variedad',
        commonUses: 'Jugos, postres, salsas y cócteles',
        imageUrl: 'assets/ALIMENTACION/maracuya.png',
      ),
      FruitInfo(
        name: 'Pera',
        description:
            'Las peras son una buena fuente de fibra soluble e insoluble, lo que contribuye a la salud digestiva. Contienen vitamina C, K y cobre, además de antioxidantes que ayudan a combatir el daño celular.',
        classification: 'Fruta pomácea con textura granulada y sabor dulce.',
        averageWeight: '150-200 gramos',
        color: 'Verde, amarillo o rojizo según la variedad',
        commonUses: 'Consumo fresco, en ensaladas, horneados y conservas',
        imageUrl: 'assets/ALIMENTACION/pera.png',
      ),
      FruitInfo(
        name: 'Naranja',
        description:
            'Las naranjas son famosas por su alto contenido de vitamina C, que fortalece el sistema inmunológico. También son ricas en fibra y contienen compuestos vegetales beneficiosos como los flavonoides.',
        classification: 'Fruta cítrica cultivada en regiones cálidas y subtropicales de todo el mundo.',
        averageWeight: '130-180 gramos',
        color: 'Naranja brillante cuando madura',
        commonUses: 'Consumo fresco, jugos, mermeladas y repostería',
        imageUrl: 'assets/ALIMENTACION/naranja.png',
      ),
      FruitInfo(
        name: 'Uvas',
        description:
            'Las uvas son ricas en antioxidantes como el resveratrol, que puede tener beneficios para la salud del corazón. También contienen vitamina K, potasio y varios antioxidantes beneficiosos.',
        classification: 'Fruta de baya que crece en racimos en la vid.',
        averageWeight: '5-10 gramos por uva',
        color: 'Verde, rojo, púrpura o negro, según la variedad',
        commonUses: 'Consumo fresco, vino, pasas, jugos y mermeladas',
        imageUrl: 'assets/ALIMENTACION/uvas.png',
      ),
      FruitInfo(
        name: 'Mora',
        description:
            'Las moras son ricas en vitamina C, fibra y antioxidantes. Contienen compuestos que pueden ayudar a combatir la inflamación y mejorar la memoria.',
        classification: 'Fruta del bosque de la familia Rubus.',
        averageWeight: '3-5 gramos por unidad',
        color: 'Negro brillante cuando madura',
        commonUses: 'Consumo fresco, mermeladas, postres y batidos',
        imageUrl: 'assets/ALIMENTACION/mora.png',
      ),
      FruitInfo(
        name: 'Kiwi',
        description:
            'El kiwi proporciona más del 100% de la ingesta diaria recomendada de vitamina C. Es rico en fibra dietética, vitamina K, vitamina E y folato, que contribuyen a la salud general.',
        classification: 'Baya comestible de la enredadera Actinidia deliciosa.',
        averageWeight: '50-80 gramos',
        color: 'Marrón exterior y verde brillante interior',
        commonUses: 'Consumo fresco, ensaladas de frutas, postres y smoothies',
        imageUrl: 'assets/ALIMENTACION/kiwi.png',
      ),
      FruitInfo(
        name: 'Sandía',
        description:
            'La sandía es refrescante y muy hidratante, compuesta por un 92% de agua. Contiene licopeno, un antioxidante que puede proteger contra ciertos tipos de cáncer y enfermedades cardíacas.',
        classification: 'Fruta de la familia de las cucurbitáceas, relacionada con calabazas y pepinos.',
        averageWeight: '5-15 kilogramos',
        color: 'Piel verde con franjas, pulpa roja o amarilla',
        commonUses: 'Consumo fresco, zumos, ensaladas y postres helados',
        imageUrl: 'assets/ALIMENTACION/sandia.png',
      ),
      FruitInfo(
        name: 'Piña',
        description:
            'La piña contiene bromelina, una enzima con propiedades antiinflamatorias. Es rica en manganeso, que apoya el metabolismo y la función antioxidante, y en vitamina C que impulsa el sistema inmunológico.',
        classification: 'Fruta tropical compuesta, formada por múltiples frutas fusionadas alrededor de un tallo central.',
        averageWeight: '1-2 kilogramos',
        color: 'Piel marrón y pulpa amarilla dorada',
        commonUses: 'Consumo fresco, jugos, postres y platos salados',
        imageUrl: 'assets/ALIMENTACION/piña.png',
      ),
      FruitInfo(
        name: 'Ciruela',
        description:
            'Las ciruelas contienen muchos antioxidantes y son conocidas por su efecto beneficioso sobre la digestión. Son ricas en vitaminas A, C y K, además de potasio y fibra.',
        classification: 'Fruta de hueso del género Prunus.',
        averageWeight: '30-100 gramos según variedad',
        color: 'Rojo, morado, amarillo o verde según la variedad',
        commonUses: 'Consumo fresco, secas (ciruelas pasas), mermeladas y postres',
        imageUrl: 'assets/ALIMENTACION/Ciruela.png',
      ),
      FruitInfo(
        name: 'Frutos Rojos',
        description:
            'Los frutos rojos (arándanos, moras, fresas y frambuesas) son excepcionalmente ricos en antioxidantes y vitamina C. Ayudan a combatir la inflamación y pueden mejorar la salud cerebral.',
        classification: 'Conjunto de pequeñas frutas de bosque con alto contenido de antocianinas.',
        averageWeight: 'Variable según el tipo (1-20 gramos por unidad)',
        color: 'Tonos rojos, azules y morados',
        commonUses: 'Consumo fresco, postres, batidos, mermeladas y repostería',
        imageUrl: 'assets/ALIMENTACION/Frutos_rojos.png',
      ),
      FruitInfo(
        name: 'Papaya',
        description:
            'La papaya contiene papaína, una enzima que ayuda a la digestión de proteínas. Es rica en vitamina C, vitamina A, folato y potasio, además de contener antioxidantes beneficiosos.',
        classification: 'Fruta tropical originaria de México y América Central.',
        averageWeight: '500-1000 gramos',
        color: 'Piel amarilla-verdosa, pulpa naranja o rojiza',
        commonUses: 'Consumo fresco, ensaladas, batidos y como ablandador de carnes',
        imageUrl: 'assets/ALIMENTACION/Papaya.png',
      ),
      FruitInfo(
        name: 'Higo',
        description:
            'Los higos son ricos en fibra, potasio, calcio y magnesio. Contienen antioxidantes y compuestos fenólicos que pueden tener propiedades antiinflamatorias y anticancerígenas.',
        classification: 'Fruto de la higuera, técnicamente una infrutescencia.',
        averageWeight: '40-60 gramos',
        color: 'Verde, morado o negro según variedad y madurez',
        commonUses: 'Consumo fresco, secos, en postres y platos salados',
        imageUrl: 'assets/ALIMENTACION/Higo.png',
      ),
      FruitInfo(
        name: 'Granada',
        description:
            'La granada es rica en antioxidantes polifenoles, especialmente punicalagins y punicalinas. Estos compuestos pueden reducir la inflamación y proteger contra enfermedades.',
        classification: 'Fruta de arbusto originaria de la región de Irán hasta el Himalaya.',
        averageWeight: '150-200 gramos',
        color: 'Exterior rojizo, semillas internas rojas brillantes',
        commonUses: 'Consumo de los arilos, jugos, salsas y en cocina internacional',
        imageUrl: 'assets/ALIMENTACION/Granada.png',
      ),
      FruitInfo(
        name: 'Grosella',
        description:
            'Las grosellas son ricas en vitamina C, antioxidantes y minerales como el potasio y el manganeso. Tienen propiedades antiinflamatorias y pueden ayudar a fortalecer el sistema inmunológico.',
        classification: 'Bayas pequeñas del género Ribes.',
        averageWeight: '1-2 gramos por unidad',
        color: 'Rojo, negro o blanco según la variedad',
        commonUses: 'Mermeladas, jaleas, zumos, postres y salsas',
        imageUrl: 'assets/ALIMENTACION/Grosella.png',
      ),
      FruitInfo(
        name: 'Mandarina',
        description:
            'Las mandarinas son excelentes fuentes de vitamina C y contienen flavonoides que actúan como antioxidantes. Son bajas en calorías y contienen fibra que ayuda a la digestión.',
        classification: 'Fruta cítrica de la familia de las rutáceas.',
        averageWeight: '80-120 gramos',
        color: 'Naranja intenso cuando madura',
        commonUses: 'Consumo fresco, zumos, postres y mermeladas',
        imageUrl: 'assets/ALIMENTACION/Mandarina.png',
      ),
      FruitInfo(
        name: 'Coco',
        description:
            'El coco es rico en grasas saludables, especialmente ácidos grasos de cadena media que pueden proporcionar energía rápida. La pulpa del coco contiene fibra y minerales como manganeso, cobre y hierro.',
        classification: 'Técnicamente una drupa, no una nuez, es la fruta del cocotero.',
        averageWeight: '1.5-2.5 kilogramos',
        color: 'Marrón exterior, pulpa blanca y agua transparente',
        commonUses: 'Agua, leche, aceite, pulpa, en cocina, postres y cosméticos',
        imageUrl: 'assets/ALIMENTACION/Coco.png',
      ),
    ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navegar a Módulos
      context.go('/modulos');
    } else if (index == 2) {
      // Navegar a Perfil
      context.go('/perfil');
    }
  }

  // Función para enfocar/desenfocar una tarjeta específica
    void _toggleCardFocus(int index) 
      
      {
      setState(() {
        // Si ya está enfocada, la desenfocamos
        if (_focusedCardIndex == index) {
          _focusedCardIndex = null;
        } else {
          // Si no está enfocada o hay otra enfocada, enfocamos esta
          _focusedCardIndex = index;
        }
      });
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
              image: AssetImage("assets/ALIMENTACION/fONDO_FRUTAS.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Light overlay for better readability
        Container(color: const Color.fromARGB(255, 206, 206, 206).withOpacity(0.7)),
        
        // Main content
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [         
                const SizedBox(height: 10),
                const Text(
                  'INFORMACIÓN DE FRUTAS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 18, 167),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Botón de regreso añadido aquí    
                Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          context.go('/inicio_alimentacion');
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
              
              // Grid of fruit cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    // El resto del código permanece igual...
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _fruitList.length,
                      itemBuilder: (context, index) {
                        // Determinar si esta tarjeta está enfocada o no
                        bool isFocused = _focusedCardIndex == index;
                        bool isAnyCardFocused = _focusedCardIndex != null;
                        
                        // Aplicar efectos visuales según el estado
                        return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: isFocused 
                            ? (Matrix4.identity()..translate(0.0, -10.0, 50.0))
                            : Matrix4.identity(),
                        transformAlignment: Alignment.center,
                        child: FlipCard(
                          fruit: _fruitList[index],
                          onTap: () => _toggleCardFocus(index),
                          isFocused: isFocused,
                          isBlurred: isAnyCardFocused && !isFocused,
                        ),
                      );
                      },
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
        primaryColor: const Color.fromARGB(255, 148, 66, 255),
      ),
    );
  }
}

// FlipCard Widget para implementar el efecto de volteo
class FlipCard extends StatefulWidget {
  final FruitInfo fruit;
  final VoidCallback onTap;
  final bool isFocused;
  final bool isBlurred;
  
  const FlipCard({
    required this.fruit,
    required this.onTap,
    required this.isFocused,
    required this.isBlurred,
    Key? key,
  }) : super(key: key);
  
  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _showFront = true;
  
  void _toggleCard() {
    setState(() {
      _showFront = !_showFront;
    });
    widget.onTap();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // Aplicar desenfoque si corresponde
        foregroundDecoration: widget.isBlurred
            ? BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              )
            : null,
        // Elevar la tarjeta seleccionada
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: widget.isFocused
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotateAnimation = Tween(begin: pi, end: 0.0).animate(animation);
            return AnimatedBuilder(
              animation: rotateAnimation,
              child: child,
              builder: (context, widget) {
                final isUnder = (ValueKey(_showFront) != child.key);
                var tilt = ((rotateAnimation.value - pi/2).abs() - pi/2) / pi/2;
                var progress = (rotateAnimation.value / pi);
                var tiltRotation = progress < 0.5 ? (progress * 2 * pi/8) : ((1 - progress) * 2 * pi/8);
                
                return Transform(
                  transform: Matrix4.rotationY(rotateAnimation.value)
                    ..setEntry(3, 0, (isUnder ? -0.003 : 0.003) * tilt)
                    ..rotateX(tiltRotation),
                  alignment: Alignment.center,
                  child: widget,
                );
              },
            );
          },
          child: _showFront
              ? _buildFrontCard(widget.fruit)
              : _buildBackCard(widget.fruit),
        ),
      ),
    );
  }
  
  // Construir la cara frontal de la tarjeta (con la imagen)
  Widget _buildFrontCard(FruitInfo fruit) {
    return Card(
      key: const ValueKey(true),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen de la fruta
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Image.asset(
                  fruit.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          // Nombre de la fruta
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 75, 18, 167),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Text(
              fruit.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Construir la cara trasera de la tarjeta (con la información)
  Widget _buildBackCard(FruitInfo fruit) {
    return Card(
      key: const ValueKey(false),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado con nombre de la fruta
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 75, 18, 167),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Text(
              fruit.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Información de la fruta
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Descripción:', fruit.description),
                  const SizedBox(height: 10),
                  _buildInfoSection('Clasificación:', fruit.classification),
                  const SizedBox(height: 8),
                  _buildInfoSection('Peso promedio:', fruit.averageWeight),
                  const SizedBox(height: 8),
                  _buildInfoSection('Color:', fruit.color),
                  const SizedBox(height: 8),
                  _buildInfoSection('Usos comunes:', fruit.commonUses),
                ],
              ),
            ),
          ),
          
          // Botón para volver
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextButton.icon(
              icon: const Icon(Icons.refresh, color: Color.fromARGB(255, 75, 18, 167)),
              label: const Text(
                'Voltear',
                style: TextStyle(color: Color.fromARGB(255, 75, 18, 167)),
              ),
              onPressed: _toggleCard,
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir cada sección de información
  Widget _buildInfoSection(String title, String content) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color.fromARGB(255, 75, 18, 167),
            ),
          ),
          TextSpan(
            text: content,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Modelo para la información de frutas
class FruitInfo {
  final String name;
  final String description;
  final String classification;
  final String averageWeight;
  final String color;
  final String commonUses;
  final String imageUrl;

  FruitInfo({
    required this.name,
    required this.description, 
    required this.classification,
    required this.averageWeight,
    required this.color,
    required this.commonUses,
    required this.imageUrl,
  });
}