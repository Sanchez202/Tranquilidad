import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class categoria extends StatefulWidget {
  const categoria({Key? key}) : super(key: key);

  @override
  State<categoria> createState() => _CategoriaLibrosScreenState();
}

class _CategoriaLibrosScreenState extends State<categoria> {
  int _selectedIndex = 0;
  final List<bool> _likedBooks = List.generate(8, (index) => false);

  final List<Book> _books = [
    Book(id: 1, title: "El arte de la guerra", imageUrl: "https://i.ibb.co/5x9DgRTh/40fa6a6657f79a3752fbf7a8501ccebd.webp"),
    Book(id: 2, title: "El arte de vivir", imageUrl: "https://i.ibb.co/4nS0DRH7/El-arte-de-vivir-Manual-de-vida-Epicteto-md.jpg"),
    Book(id: 3, title: "El tratado de la pintura", imageUrl: "https://i.ibb.co/dRYLTKL/images.jpg"),
    Book(id: 4, title: "Historia del arte", imageUrl: "https://i.ibb.co/Zpk01GWz/9788476002681.jpg"),
    Book(id: 5, title: "Los artes de la india", imageUrl: "https://i.ibb.co/6JJMbj0P/download.jpg"),
    Book(id: 6, title: "Los principios del arte", imageUrl: "https://i.ibb.co/tMVggdwd/feeae55d28a6b0a0750df8e115da1200.webp"),
    Book(id: 7, title: "El arte de amar", imageUrl: "https://i.ibb.co/GfwkjMq0/download.jpg"),
    Book(id: 8, title: "Historia del arte", imageUrl: "https://i.ibb.co/0RYcrZzY/410y-VPIXg-ZL-AC-UF894-1000-QL80.jpg"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.ibb.co/k6Hx7FSM/caa5c962-c5c1-4319-a78a-a9d9e92a17d3.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Nuevo botón para navegar a la página de detalles
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla de detalles con el ID del primer libro por defecto
                    context.go('/detalles-libro/1');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF59009A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Ver Detalles del Libro',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Lista de libros
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      return BookCard(
                        book: _books[index],
                        isLiked: _likedBooks[index],
                        onLikeToggle: () {
                          setState(() {
                            _likedBooks[index] = !_likedBooks[index];
                          });
                        },
                        bookId: _books[index].id,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}

class Book {
  final String title;
  final String imageUrl;
  final int id;

  Book({required this.title, required this.imageUrl, required this.id});
}

class BookCard extends StatelessWidget {
  final Book book;
  final bool isLiked;
  final VoidCallback onLikeToggle;
  final int bookId;

  const BookCard({
    Key? key,
    required this.book,
    required this.isLiked,
    required this.onLikeToggle,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de detalles cuando se toca la tarjeta
        context.go('/detalles-libro/$bookId');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: Colors.white,
                      child: Image.network(
                        book.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.blue[300]!),
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(Icons.book_rounded, size: 50, color: Colors.grey[400]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[500]!,
                          Colors.grey[300]!,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onLikeToggle,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? const Color.fromARGB(255, 96, 28, 169) : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              // Botón "Ver detalles" en la parte inferior
              Positioned(
                bottom: 45,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Navegar a la pantalla de detalles con el ID del libro
                      context.go('/detalles-libro/$bookId');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF59009A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Ver detalles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}