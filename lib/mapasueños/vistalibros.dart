import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:tranquilidad_app/Api/book_api_service.dart';


class DetallesLibroScreen extends StatefulWidget {
  final int bookId;

  const DetallesLibroScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  _DetallesLibroScreenState createState() => _DetallesLibroScreenState();
}

class _DetallesLibroScreenState extends State<DetallesLibroScreen> {
  // Estado
  Book? book;
  List<Comment> comments = [];
  double averageRating = 0;
  int userRating = 0;
  bool isLoading = true;
  bool isSendingComment = false;
  TextEditingController commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar datos
    loadData();
  }

  @override
  void dispose() {
    commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Cargar todos los datos necesarios
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Cargar en paralelo para mejor rendimiento
      final bookFuture = BookApiService.getBook(widget.bookId);
      final commentsFuture = BookApiService.getComments(widget.bookId);
      final ratingFuture = BookApiService.calculateAverageRating(widget.bookId);
      final userRatingFuture = BookApiService.getUserRating(widget.bookId);
      
      final bookResult = await bookFuture;
      final commentsResult = await commentsFuture;
      final ratingResult = await ratingFuture;
      final userRatingResult = await userRatingFuture;
      
      if (mounted) {
        setState(() {
          book = bookResult;
          comments = commentsResult;
          averageRating = ratingResult;
          userRating = userRatingResult;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  // Refrescar datos
  Future<void> refreshData() async {
    try {
      final commentsFuture = BookApiService.getComments(widget.bookId);
      final ratingFuture = BookApiService.calculateAverageRating(widget.bookId);
      
      final commentsResult = await commentsFuture;
      final ratingResult = await ratingFuture;
      
      if (mounted) {
        setState(() {
          comments = commentsResult;
          averageRating = ratingResult;
        });
      }
      
      return Future.value();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar datos: $e')),
        );
      }
      return Future.value();
    }
  }

  // Enviar puntuación
  Future<void> submitRating(int rating) async {
    try {
      final success = await BookApiService.submitRating(widget.bookId, rating);
      
      if (success && mounted) {
        setState(() {
          userRating = rating;
        });
        
        // Recalcular el promedio
        final newAverage = await BookApiService.calculateAverageRating(widget.bookId);
        
        if (mounted) {
          setState(() {
            averageRating = newAverage;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Calificación enviada con éxito!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar calificación: $e')),
        );
      }
    }
  }

  // Enviar comentario
  Future<void> sendComment() async {
    final text = commentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe un comentario')),
      );
      return;
    }

    if (text.replaceAll(RegExp(r'\s'), '').length > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El comentario no debe superar los 500 caracteres')),
      );
      return;
    }

    setState(() {
      isSendingComment = true;
    });

    try {
      final now = DateTime.now().toIso8601String().replaceAll('T', ' ').substring(0, 19);
      final comment = Comment(
        id: 0,
        libroId: widget.bookId,
        comentario: text,
        fechacreacion: now,
      );

      final newComment = await BookApiService.addComment(comment);
      
      if (mounted) {
        setState(() {
          comments.add(newComment);
          commentController.clear();
          isSendingComment = false;
        });
        
        // Desplazar hacia abajo para ver el nuevo comentario
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isSendingComment = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar comentario: $e')),
        );
      }
    }
  }

  // Borrar comentario
  Future<void> deleteComment(int commentId) async {
    try {
      final success = await BookApiService.deleteComment(commentId, widget.bookId);
      
      if (success && mounted) {
        setState(() {
          comments.removeWhere((comment) => comment.id == commentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario eliminado con éxito')),
        );
      } else if (mounted) {
        throw Exception('Error al eliminar comentario');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar comentario: $e')),
        );
      }
    }
  }

  // Formatear fecha
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMMM, yyyy HH:mm', 'es').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Abrir enlace del libro
  Future<void> openBookLink() async {
    if (book == null || book!.link.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay enlace disponible para este libro')),
        );
      }
      return;
    }
    
    final Uri url = Uri.parse(book!.link);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se pudo abrir el enlace');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book?.titulo ?? 'Detalles del libro'),
        backgroundColor: const Color(0xFF59009A),
        foregroundColor: Colors.white,
        actions: [
          // Botón de actualizar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : refreshData,
            tooltip: 'Actualizar datos',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: const Color(0xFF59009A),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/libros.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.white.withOpacity(0.7),
            child: isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF59009A)))
              : book == null
                ? const Center(child: Text('No se encontró información del libro'))
                : CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Detalles del libro
                              bookDetailsSection(),
                              
                              const SizedBox(height: 20),
                              
                              // Sección de comentarios
                              commentSection(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget bookDetailsSection() {
    if (book == null) return const SizedBox.shrink();
    
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del libro con imagen
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portada del libro
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book?.portadaUrl ?? 'https://via.placeholder.com/150x200?text=Sin+Portada',
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text('Sin portada'),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Detalles del libro
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book?.titulo ?? '',
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF59009A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            const TextSpan(
                              text: 'Autor: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: book?.autor ?? 'Desconocido'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            const TextSpan(
                              text: 'Editorial: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: book?.editorial ?? 'Desconocida'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Sistema de calificación con estrellas
                      Row(
                        children: [
                          for (int i = 1; i <= 5; i++)
                            GestureDetector(
                              onTap: () => submitRating(i),
                              child: Icon(
                                i <= userRating ? Icons.star : Icons.star_border,
                                color: const Color(0xFF6A0DAD),
                                size: 24,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Descripción del libro
            const Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book?.descripcionlibro ?? 'Sin descripción disponible',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            
            const SizedBox(height: 16),
            
            // Botón para leer el libro
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: openBookLink,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: const Color(0xFF7A00CF),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Leer libro'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentSection() {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comentarios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF59009A),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Formulario para agregar comentario
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF59009A)),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Contador de caracteres
            Text(
              '${commentController.text.replaceAll(RegExp(r'\s'), '').length}/500 caracteres',
              style: TextStyle(
                color: commentController.text.replaceAll(RegExp(r'\s'), '').length > 500 
                    ? Colors.red 
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botones de comentario
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón Cancelar
                OutlinedButton(
                  onPressed: isSendingComment 
                      ? null 
                      : () => commentController.clear(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700], 
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Cancelar'),
                ),
                
                const SizedBox(width: 12),
                
                // Botón Comentar
                ElevatedButton(
                  onPressed: isSendingComment ? null : sendComment,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: const Color(0xFF59009A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: isSendingComment 
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Comentar'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Lista de comentarios
            comments.isEmpty 
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No hay comentarios aún. ¡Sé el primero en comentar!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return CommentCard(
                        comment: comment,
                        formattedDate: formatDate(comment.fechacreacion),
                        onDelete: () => deleteComment(comment.id),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

// Widget para cada tarjeta de comentario
class CommentCard extends StatelessWidget {
  final Comment comment;
  final String formattedDate;
  final VoidCallback onDelete;

  const CommentCard({
    Key? key,
    required this.comment,
    required this.formattedDate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      elevation: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: const Color(0xFF59009A), width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del comentario
              Row(
                children: [
                  const Text(
                    'Usuario',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Text(' | ', style: TextStyle(color: Colors.grey)),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Contenido del comentario
              Text(
                comment.comentario,
                style: const TextStyle(fontSize: 14),
              ),
              
              const SizedBox(height: 12),
              
              // Acciones del comentario
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 16, color: Color(0xFF59009A)),
                    label: const Text(
                      'Eliminar',
                      style: TextStyle(color: Color(0xFF59009A)),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}