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
  static const String ratingApiUrl = "$baseApiUrl/calificaciones";
  static const String commentsApiUrl = "$baseApiUrl/comentarios";
  static const String averageApiUrl = "$baseApiUrl/promediocalificacion";
  static String getBookApiUrl(int bookId) => "$baseApiUrl/api/libros/$bookId";

  // Headers estándar para las solicitudes
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Obtener datos de un libro específico
  static Future<Book> getBook(int bookId) async {
    try {
      final response = await http.get(Uri.parse(getBookApiUrl(bookId)));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Book.fromJson(data);
      } else {
        throw Exception('Error al cargar el libro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }

  // Obtener comentarios de un libro
  static Future<List<Comment>> getComments(int bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$commentsApiUrl?libro_id=$bookId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final commentsData = data['data'] ?? data;
        
        if (commentsData is List) {
          return commentsData.map((item) => Comment.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception('Error al cargar comentarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud de comentarios: $e');
    }
  }

  // Enviar un nuevo comentario
  static Future<Comment> addComment(Comment comment) async {
    try {
      final response = await http.post(
        Uri.parse(commentsApiUrl),
        headers: headers,
        body: json.encode(comment.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return Comment.fromJson(data);
      } else {
        throw Exception('Error al enviar comentario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud de envío de comentario: $e');
    }
  }

  // Eliminar un comentario
  static Future<bool> deleteComment(int commentId, int bookId) async {
    try {
      final response = await http.delete(
        Uri.parse('$commentsApiUrl/$commentId?libro_id=$bookId'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al eliminar comentario: $e');
    }
  }

  // Obtener calificaciones de un libro
  static Future<List<dynamic>> getRatings(int bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$ratingApiUrl?libro_id=$bookId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List ? data : (data['data'] ?? []);
      } else {
        throw Exception('Error al cargar calificaciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud de calificaciones: $e');
    }
  }

  // Calcular el promedio de calificaciones
  static Future<double> calculateAverageRating(int bookId) async {
    try {
      final ratings = await getRatings(bookId);
      
      if (ratings.isEmpty) return 0;
      
      double sum = 0;
      for (var rating in ratings) {
        sum += double.parse(rating['estrellas'].toString());
      }
      
      final average = sum / ratings.length;
      
      // Guardar el promedio en la API
      await saveAverageRating(bookId, average, ratings.length);
      
      return average;
    } catch (e) {
      throw Exception('Error al calcular el promedio: $e');
    }
  }

  // Guardar el promedio de calificaciones
  static Future<void> saveAverageRating(int bookId, double average, int totalRatings) async {
    try {
      final body = {
        'libro_id': bookId,
        'promedioestrellas': average.toStringAsFixed(1),
        'numerodecalificaciones': totalRatings
      };

      // Intentar POST primero
      var response = await http.post(
        Uri.parse(averageApiUrl),
        headers: headers,
        body: json.encode(body),
      );

      // Si falla, intentar PUT
      if (response.statusCode != 200 && response.statusCode != 201) {
        await http.put(
          Uri.parse('$averageApiUrl/$bookId'),
          headers: headers,
          body: json.encode(body),
        );
      }
    } catch (e) {
      throw Exception('Error al guardar promedio: $e');
    }
  }

  // Enviar calificación del usuario
  static Future<bool> submitRating(int bookId, int rating) async {
    try {
      final response = await http.post(
        Uri.parse(ratingApiUrl),
        headers: headers,
        body: json.encode({
          'libro_id': bookId,
          'estrellas': rating.toDouble(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Guardar calificación localmente
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('libro_${bookId}_userRating', rating);
        
        return true;
      } else {
        throw Exception('Error al enviar calificación: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud de calificación: $e');
    }
  }

  // Obtener calificación del usuario desde localStorage
  static Future<int> getUserRating(int bookId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt('libro_${bookId}_userRating') ?? 0;
    } catch (e) {
      throw Exception('Error al obtener calificación del usuario: $e');
    }
  }
}