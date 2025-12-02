import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// Root widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTasks',
      home: TasksHome(),
    );
  }
}

// Task class
class Task {
  String title;
  String priority;
  bool done = false;

  Task(this.title, this.priority);
}

// Home Page
class TasksHome extends StatefulWidget {
  const TasksHome({Key? key}) : super(key: key);

  @override
  State<TasksHome> createState() => _TasksHomeState();
}

class _TasksHomeState extends State<TasksHome> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedPriority = 'Low';
  final List<Task> _tasks = [];
  String _message = '';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  int get totalTasks => _tasks.length;

  int get doneTasks {
    int c = 0;
    for (var t in _tasks) {
      if (t.done) c++;
    }
    return c;
  }

  int get remainingTasks => totalTasks - doneTasks;

  void _addTask() {
    String title = _titleController.text.trim();

    if (title.isEmpty) {
      setState(() {
        _message = 'Please enter a task title';
      });
      return;
    }

    setState(() {
      _tasks.add(Task(title, _selectedPriority));
      _titleController.clear();
      _selectedPriority = 'Low';
      _message = 'Task added!';
    });
  }

  void _toggleDone(int index, bool? value) {
    setState(() {
      _tasks[index].done = value ?? false;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Color _priorityColor(String p) {
    if (p == 'Low') return Colors.green;
    if (p == 'Medium') return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7ECF4),
      appBar: AppBar(
        title: const Text('MyTasks'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Display Logo
            Image.asset(
              'assets/Todo_list.jpg',
              height: 140,
            ),
            const SizedBox(height: 20),

            // Summary
            Text(
              'Total: $totalTasks   Done: $doneTasks   Remaining: $remainingTasks',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Message
            Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8.0),

            // Task Input
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter task title',
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            // Priority Selection
            const Text('Priority', style: TextStyle(fontSize: 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 'Low',
                  groupValue: _selectedPriority,
                  onChanged: (val) {
                    setState(() {
                      _selectedPriority = val as String;
                    });
                  },
                ),
                const Text('Low'),
                Radio(
                  value: 'Medium',
                  groupValue: _selectedPriority,
                  onChanged: (val) {
                    setState(() {
                      _selectedPriority = val as String;
                    });
                  },
                ),
                const Text('Medium'),
                Radio(
                  value: 'High',
                  groupValue: _selectedPriority,
                  onChanged: (val) {
                    setState(() {
                      _selectedPriority = val as String;
                    });
                  },
                ),
                const Text('High'),
              ],
            ),

            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade300,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                'Add Task',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 10),

            // Task List
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('No tasks yet.'))
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  Task t = _tasks[index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Checkbox(
                        value: t.done,
                        onChanged: (val) {
                          _toggleDone(index, val);
                        },
                      ),
                      title: Text(
                        t.title,
                        style: TextStyle(
                          decoration: t.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        t.priority,
                        style: TextStyle(color: _priorityColor(t.priority)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}