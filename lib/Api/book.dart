class Book {
  final int id;
  final String titulo;
  final String autor;
  final String editorial;
  final String descripcionlibro;
  final String portadaUrl;
  final String link;

  Book({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.editorial,
    required this.descripcionlibro,
    required this.portadaUrl,
    required this.link,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      editorial: json['editorial'],
      descripcionlibro: json['descripcionlibro'],
      portadaUrl: json['portadaUrl'],
      link: json['link'],
    );
  }
}