import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';

// Modelo para las tareas - movido fuera de la clase de estado
class Task {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime dueDate;

  Task({
    required this.title, 
    required this.description, 
    required this.startDate, 
    required this.dueDate
  });
}

// Clase para botones de acción
class ActionButton {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });
}

class TaskBoard extends StatefulWidget {
  const TaskBoard({Key? key}) : super(key: key);

  @override
  State<TaskBoard> createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoard> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Datos de ejemplo
  final List<Task> _todoTasks = [
    Task(
      title: "44", 
      description: "44", 
      startDate: DateTime(2025, 4, 2), 
      dueDate: DateTime(2025, 4, 29)
    ),
  ];

  final List<Task> _inProgressTasks = [
    Task(
      title: "s", 
      description: "wef", 
      startDate: DateTime(2025, 3, 31), 
      dueDate: DateTime(2025, 4, 22)
    ),
  ];

  final List<Task> _completedTasks = [];

  // Función para mover tareas entre columnas
  void _moveTaskToProgress(int index) {
    setState(() {
      _inProgressTasks.add(_todoTasks[index]);
      _todoTasks.removeAt(index);
    });
  }

  void _moveTaskToCompleted(int index) {
    setState(() {
      _completedTasks.add(_inProgressTasks[index]);
      _inProgressTasks.removeAt(index);
    });
  }

  void _moveTaskBackToTodo(int index) {
    setState(() {
      _todoTasks.add(_inProgressTasks[index]);
      _inProgressTasks.removeAt(index);
    });
  }

  void _deleteTask(List<Task> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  void _editTask(List<Task> list, int index) {
    Task task = list[index];
    _showEditTaskDialog(list, index, task.title, task.description, task.startDate, task.dueDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false, // Evita interferencias con el BottomNavigationBar
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 6, 6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TabBar(
                      isScrollable: false, // Asegura que no sea scrollable
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0), // Reduce el padding horizontal
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color.fromARGB(255, 85, 2, 51).withOpacity(0.3),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      tabs: [
                        Tab(
                          child: FittedBox( // Envuelve el contenido en un FittedBox
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Usa minimal size
                              children: [
                                const Text('Tareas'),
                                const SizedBox(width: 4.0), // Reduce espacio entre texto y contador
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    '${_todoTasks.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('En Progreso'),
                                const SizedBox(width: 4.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    '${_inProgressTasks.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Completado'),
                                const SizedBox(width: 4.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    '${_completedTasks.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const ClampingScrollPhysics(), // Previene el scroll excesivo entre tabs
                      children: [
                        // Tareas pendientes
                        _buildTaskList(
                          _todoTasks,
                          Colors.pink.shade200,
                          (index) => [
                            ActionButton(
                              label: 'Mover a Progreso',
                              color: Colors.pink.shade200,
                              onPressed: () => _moveTaskToProgress(index),
                            ),
                            ActionButton(
                              label: 'Editar',
                              color: Colors.blue.shade400,
                              onPressed: () => _editTask(_todoTasks, index),
                            ),
                            ActionButton(
                              label: 'Eliminar',
                              color: Colors.red.shade400,
                              onPressed: () => _deleteTask(_todoTasks, index),
                            ),
                          ],
                          true,
                        ),
                        
                        // Tareas en progreso
                        _buildTaskList(
                          _inProgressTasks,
                          Colors.pink.shade200,
                          (index) => [
                            ActionButton(
                              label: 'Completar',
                              color: Colors.pink.shade200,
                              onPressed: () => _moveTaskToCompleted(index),
                            ),
                            ActionButton(
                              label: 'Volver a Tareas',
                              color: Colors.pink.shade200,
                              onPressed: () => _moveTaskBackToTodo(index),
                            ),
                            ActionButton(
                              label: 'Editar',
                              color: Colors.blue.shade400,
                              onPressed: () => _editTask(_inProgressTasks, index),
                            ),
                            ActionButton(
                              label: 'Eliminar',
                              color: Colors.red.shade400,
                              onPressed: () => _deleteTask(_inProgressTasks, index),
                            ),
                          ],
                          false,
                        ),
                        
                        // Tareas completadas
                        _buildTaskList(
                          _completedTasks,
                          Colors.deepPurple.shade200,
                          (index) => [
                            ActionButton(
                              label: 'Eliminar',
                              color: Colors.red.shade400,
                              onPressed: () => _deleteTask(_completedTasks, index),
                            ),
                          ],
                          false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildTaskList(
    List<Task> tasks, 
    Color color, 
    List<ActionButton> Function(int) actionGenerator, 
    bool showAddButton
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Expanded(
            child: tasks.isEmpty
              ? Center(
                  child: Text(
                    'No hay tareas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(), // Añade rebote suave
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(tasks[index], color, actionGenerator(index), index);
                  },
                ),
          ),
          if (showAddButton)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Añade padding inferior
              child: GestureDetector(
                onTap: () {
                  // Lógica para añadir tarea
                  _showAddTaskDialog();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  margin: const EdgeInsets.only(top: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade200,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Center(
                    child: Text(
                      '+ Añadir tarea',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, Color color, List<ActionButton> actions, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Inicio: ${_formatDate(task.startDate)}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Límite: ${_formatDate(task.dueDate)}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (actions.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView( // Permite scroll horizontal si hay muchos botones
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row( // Cambia Wrap por Row con scroll horizontal
                  children: actions.map((action) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: action.onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: action.color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(action.label),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      barrierDismissible: false, // Evita cierre accidental
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir nueva tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _todoTasks.add(Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      startDate: startDate,
                      dueDate: dueDate,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(List<Task> list, int index, String currentTitle, String currentDescription, DateTime currentStartDate, DateTime currentDueDate) {
    final TextEditingController titleController = TextEditingController(text: currentTitle);
    final TextEditingController descriptionController = TextEditingController(text: currentDescription);
    DateTime startDate = currentStartDate;
    DateTime dueDate = currentDueDate;

    showDialog(
      context: context,
      barrierDismissible: false, // Evita cierre accidental
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    // Reemplazar la tarea con una nueva que tenga los datos actualizados
                    list[index] = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      startDate: startDate,
                      dueDate: dueDate,
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}