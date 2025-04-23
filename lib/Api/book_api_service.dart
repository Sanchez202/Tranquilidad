// lib/Api/book_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Modelo para el libro
class Book {
  final int id;
  final String titulo;
  final String descripcionlibro;
  final String autor;
  final String editorial;
  final String portadaUrl;
  final String link;

  Book({
    required this.id,
    required this.titulo,
    required this.descripcionlibro,
    required this.autor,
    required this.editorial,
    required this.portadaUrl,
    required this.link,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcionlibro: json['descripcionlibro'] ?? '',
      autor: json['autor'] ?? '',
      editorial: json['editorial'] ?? '',
      portadaUrl: json['portada_url'] ?? '',
      link: json['link'] ?? '',
    );
  }
}

// Modelo para comentario
class Comment {
  final int id;
  final int libroId;
  final String comentario;
  final String fechacreacion;

  Comment({
    required this.id,
    required this.libroId,
    required this.comentario,
    required this.fechacreacion,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      libroId: json['libro_id'] ?? 0,
      comentario: json['comentario'] ?? '',
      fechacreacion: json['fechacreacion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'libro_id': libroId,
      'comentario': comentario,
      'fechacreacion': fechacreacion,
    };
  }
}

class BookApiService {
  // URL base para la API
  static const String baseApiUrl = "https://back1-production-67bf.up.railway.app/v1";
  
  // URLs específicas
  static String getBookApiUrl(int bookId) => "$baseApiUrl/api/libros/$bookId";
  static String getRatingsApiUrl(int bookId) => "$baseApiUrl/api/libros/$bookId/calificaciones";
  static String getCommentsApiUrl(int bookId) => "$baseApiUrl/api/libros/$bookId/comentarios";
  static String getAverageApiUrl(int bookId) => "$baseApiUrl/api/libros/$bookId/promediocalificacion";

  // Headers estándar para las solicitudes
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Obtener datos de un libro específico
  static Future<Book> getBook(int bookId) async {
    print('Intentando obtener libro con ID: $bookId');
    print('URL: ${getBookApiUrl(bookId)}');
    
    try {
      final response = await http.get(Uri.parse(getBookApiUrl(bookId)));
      
      print('Respuesta: ${response.statusCode}');
      print('Cuerpo: ${response.body.substring(0, min(100, response.body.length))}...');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final book = Book.fromJson(data);
        print('Libro obtenido: ${book.titulo}');
        return book;
      } else {
        throw Exception('Error al cargar el libro: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en getBook: $e');
      throw Exception('Error en la solicitud: $e');
    }
  }

  // Obtener comentarios de un libro
  static Future<List<Comment>> getComments(int bookId) async {
    print('Obteniendo comentarios para libro ID: $bookId');
    print('URL: ${getCommentsApiUrl(bookId)}');
    
    try {
      final response = await http.get(
        Uri.parse(getCommentsApiUrl(bookId)),
      );
      
      print('Respuesta comentarios: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final commentsData = data['data'] ?? data;
        
        if (commentsData is List) {
          final comments = commentsData.map((item) => Comment.fromJson(item)).toList();
          print('Comentarios obtenidos: ${comments.length}');
          return comments;
        }
        print('No hay comentarios o formato incorrecto');
        return [];
      } else {
        throw Exception('Error al cargar comentarios: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en getComments: $e');
      throw Exception('Error en la solicitud de comentarios: $e');
    }
  }

  // Enviar un nuevo comentario
  static Future<Comment> addComment(Comment comment) async {
    print('Enviando comentario para libro ID: ${comment.libroId}');
    print('URL: ${getCommentsApiUrl(comment.libroId)}');
    
    try {
      final response = await http.post(
        Uri.parse(getCommentsApiUrl(comment.libroId)),
        headers: headers,
        body: json.encode(comment.toJson()),
      );

      print('Respuesta: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final newComment = Comment.fromJson(data);
        print('Comentario creado con ID: ${newComment.id}');
        return newComment;
      } else {
        throw Exception('Error al enviar comentario: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en addComment: $e');
      throw Exception('Error en la solicitud de envío de comentario: $e');
    }
  }

  // Eliminar un comentario
  static Future<bool> deleteComment(int commentId, int bookId) async {
    print('Eliminando comentario ID: $commentId del libro ID: $bookId');
    print('URL: ${getCommentsApiUrl(bookId)}/$commentId');
    
    try {
      final response = await http.delete(
        Uri.parse('${getCommentsApiUrl(bookId)}/$commentId'),
        headers: headers,
      );

      print('Respuesta: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('Comentario eliminado con éxito');
        return true;
      } else {
        print('Error al eliminar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error en deleteComment: $e');
      throw Exception('Error al eliminar comentario: $e');
    }
  }

  // Obtener calificaciones de un libro
  static Future<List<dynamic>> getRatings(int bookId) async {
    print('Obteniendo calificaciones para libro ID: $bookId');
    print('URL: ${getRatingsApiUrl(bookId)}');
    
    try {
      final response = await http.get(
        Uri.parse(getRatingsApiUrl(bookId)),
      );
      
      print('Respuesta calificaciones: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ratingsData = data is List ? data : (data['data'] ?? []);
        print('Calificaciones obtenidas: ${ratingsData.length}');
        return ratingsData;
      } else {
        throw Exception('Error al cargar calificaciones: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en getRatings: $e');
      throw Exception('Error en la solicitud de calificaciones: $e');
    }
  }

  // Calcular el promedio de calificaciones
  static Future<double> calculateAverageRating(int bookId) async {
    print('Calculando promedio para libro ID: $bookId');
    
    try {
      final ratings = await getRatings(bookId);
      
      if (ratings.isEmpty) {
        print('No hay calificaciones, retornando 0');
        return 0;
      }
      
      double sum = 0;
      for (var rating in ratings) {
        sum += double.parse(rating['estrellas'].toString());
      }
      
      final average = sum / ratings.length;
      print('Promedio calculado: $average');
      
      // Guardar el promedio en la API
      await saveAverageRating(bookId, average, ratings.length);
      
      return average;
    } catch (e) {
      print('Error en calculateAverageRating: $e');
      throw Exception('Error al calcular el promedio: $e');
    }
  }

  // Guardar el promedio de calificaciones
  static Future<void> saveAverageRating(int bookId, double average, int totalRatings) async {
    print('Guardando promedio para libro ID: $bookId');
    print('URL: ${getAverageApiUrl(bookId)}');
    
    try {
      final body = {
        'libro_id': bookId,
        'promedioestrellas': average.toStringAsFixed(1),
        'numerodecalificaciones': totalRatings
      };

      print('Enviando datos: $body');
      
      // Intentar POST primero
      var response = await http.post(
        Uri.parse(getAverageApiUrl(bookId)),
        headers: headers,
        body: json.encode(body),
      );

      print('Respuesta POST: ${response.statusCode}');
      
      // Si falla, intentar PUT
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Intentando PUT');
        response = await http.put(
          Uri.parse('${getAverageApiUrl(bookId)}/$bookId'),
          headers: headers,
          body: json.encode(body),
        );
        print('Respuesta PUT: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en saveAverageRating: $e');
      throw Exception('Error al guardar promedio: $e');
    }
  }

  // Enviar calificación del usuario
  static Future<bool> submitRating(int bookId, int rating) async {
    print('Enviando calificación $rating para libro ID: $bookId');
    print('URL: ${getRatingsApiUrl(bookId)}');
    
    try {
      final response = await http.post(
        Uri.parse(getRatingsApiUrl(bookId)),
        headers: headers,
        body: json.encode({
          'libro_id': bookId,
          'estrellas': rating.toDouble(),
        }),
      );

      print('Respuesta: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Guardar calificación localmente
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('libro_${bookId}_userRating', rating);
        print('Calificación guardada localmente');
        
        return true;
      } else {
        throw Exception('Error al enviar calificación: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en submitRating: $e');
      throw Exception('Error en la solicitud de calificación: $e');
    }
  }

  // Obtener calificación del usuario desde localStorage
  static Future<int> getUserRating(int bookId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final rating = prefs.getInt('libro_${bookId}_userRating') ?? 0;
      print('Calificación del usuario para libro ID $bookId: $rating');
      return rating;
    } catch (e) {
      print('Error en getUserRating: $e');
      throw Exception('Error al obtener calificación del usuario: $e');
    }
  }
}

// Función auxiliar para evitar errores
int min(int a, int b) {
  return a < b ? a : b;
}