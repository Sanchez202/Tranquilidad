import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import '../Alimentacion/models/post.dart';
import '../Alimentacion/models/comment.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<Post> _posts = [];
  final _postController = TextEditingController();
  final uuid = const Uuid();

  void _addPost(String content) {
    if (content.isEmpty) return;
    setState(() {
      _posts.add(Post(id: uuid.v4(), content: content));
    });
    _postController.clear();
  }

  void _addComment(Post post, String content) {
    if (content.isEmpty) return;
    setState(() {
      post.comments.add(Comment(id: uuid.v4(), content: content));
    });
  }

  void _deletePost(String postId) {
    setState(() {
      _posts.removeWhere((post) => post.id == postId);
    });
  }

  void _likePost(Post post) {
    setState(() {
      post.likes += 1;
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Imagen de fondo que cubre toda la pantalla
        Positioned.fill(
          child: Image.asset(
            'assets/Alimentacion/Fondo_Test.png',
            fit: BoxFit.cover,
          ),
        ),

        // Contenido con AppBar personalizado encima de la imagen
        Column(
          children: [
            const CustomAppBar(), // Asegúrate de que este tenga fondo transparente si quieres ver la imagen

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _postController,
                decoration: InputDecoration(
                  labelText: '¿Qué quieres compartir?',
                  fillColor: Colors.white70,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _addPost(_postController.text),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (ctx, i) {
                  final post = _posts[i];
                  final commentController = TextEditingController();

                  return Card(
                    color: Colors.white70,
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/Alimentacion/User1.png'), // Asegúrate de tener esta imagen
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Usuario Demo', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(post.content, style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Likes: ${post.likes}'),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.thumb_up,
                                      color: Colors.deepPurple,  // Aquí se le asigna el color
                                    ),
                                    onPressed: () => _likePost(post),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deletePost(post.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                         const Divider(),
                              const Text('Comentarios:'),
                              ...post.comments.map((c) => Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundImage: AssetImage('assets/Alimentacion/User2.png'),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'UsuarioComentó: ',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 7, 7, 7), // Color más oscuro
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: c.content,
                                            style: const TextStyle(
                                              color: Colors.black, // Comentario normal
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),


                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'Agregar comentario',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  _addComment(post, commentController.text);
                                  commentController.clear();
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Navegación inferior sobre todo lo demás
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomNavBar(
            selectedIndex: 1,
            onItemSelected: (int index) {
              if (index == 0) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    ),
  );
}
}

