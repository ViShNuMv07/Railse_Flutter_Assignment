import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TaskStatus { notStarted, started, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final String assignee;
  final String priority;
  DateTime startDate;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    required this.priority,
    required this.startDate,
    this.status = TaskStatus.notStarted,
  });
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(
      id: 'Order-1043',
      title: 'Arrange Pickup',
      description: '',
      assignee: 'Sandhya',
      priority: 'High Priority',
      startDate: DateTime(2025, 8, 9),
      // Making it overdue
      status: TaskStatus.started,
    ),
    Task(
      id: 'Entity-2559',
      title: 'Adhoc Task',
      description: '',
      assignee: 'Arman',
      priority: '',
      startDate: DateTime(2025, 8, 9),
      // Making it overdue
      status: TaskStatus.started,
    ),
    Task(
      id: 'Order-1020',
      title: 'Collect Payment',
      description: '',
      assignee: 'Sandhya',
      priority: 'High Priority',
      startDate: DateTime(2025, 8, 9),
      // Making it overdue
      status: TaskStatus.started,
    ),
    Task(
      id: 'Order-194',
      title: 'Arrange Delivery',
      description: '',
      assignee: 'Prashant',
      priority: '',
      startDate: DateTime(2024, 8, 20),
      status: TaskStatus.completed,
    ),
    Task(
      id: 'Entity-2184',
      title: 'Share Company Profile',
      description: '',
      assignee: 'Asif Khan K',
      priority: '',
      startDate: DateTime(2024, 8, 22),
      status: TaskStatus.completed,
    ),
    Task(
      id: 'Entity-472',
      title: 'Add Followup',
      description: '',
      assignee: 'Jivik',
      priority: '',
      startDate: DateTime(2024, 8, 25),
      status: TaskStatus.completed,
    ),
    Task(
      id: 'Enquiry-3563',
      title: 'Convert Enquiry',
      description: '',
      assignee: 'Prashant',
      priority: '',
      startDate: DateTime(2025, 8, 7),
      status: TaskStatus.notStarted,
    ),
    Task(
      id: 'Order-176',
      title: 'Arrange Pickup',
      description: '',
      assignee: 'Prashant',
      priority: 'High Priority',
      startDate: DateTime(2025, 8, 8),
      status: TaskStatus.notStarted,
    ),
  ];

  void _updateTaskStatus(String taskId, TaskStatus newStatus) {
    setState(() {
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex].status = newStatus;
      }
    });
  }

  Future<void> _editDeadline(String taskId) async {
    final taskIndex = tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = tasks[taskIndex];

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: task.startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025, 12, 31),
    );

    if (pickedDate != null) {
      setState(() {
        tasks[taskIndex].startDate = pickedDate;
      });
    }
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String taskId = '';
        String title = '';
        String assignee = '';
        String priority = '';
        DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Task ID',
                        hintText: 'enter order id',
                      ),
                      onChanged: (value) => taskId = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'enter title',
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Assignee',
                        hintText: 'enter name',
                      ),
                      onChanged: (value) => assignee = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Priority'),
                      value: priority.isEmpty ? null : priority,
                      items: const [
                        DropdownMenuItem(value: '', child: Text('Normal')),
                        DropdownMenuItem(
                          value: 'High Priority',
                          child: Text('High Priority'),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => priority = value ?? ''),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        'Due Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025, 12, 31),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                dialogBackgroundColor: Colors.lightBlue.shade100, // Dialog background
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                    )

                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue.shade800),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (taskId.isNotEmpty &&
                        title.isNotEmpty &&
                        assignee.isNotEmpty) {
                      final newTask = Task(
                        id: taskId,
                        title: title,
                        description: '',
                        assignee: assignee,
                        priority: priority,
                        startDate: selectedDate,
                        status: TaskStatus.notStarted,
                      );

                      this.setState(() {
                        tasks.add(newTask);
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Add Task',
                    style: TextStyle(color: Colors.blue.shade800),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: tasks.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return TaskCard(
            task: tasks[index],
            onStatusUpdate: _updateTaskStatus,
            onEditDeadline: _editDeadline,
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: _addNewTask,
          backgroundColor: Colors.blue,
          elevation: 6,
          child: const Icon(Icons.add, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(String, TaskStatus) onStatusUpdate;
  final Function(String) onEditDeadline;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusUpdate,
    required this.onEditDeadline,
  });

  String _getStatusText() {
    final now = DateTime.now();
    final difference = task.startDate.difference(now).inDays;

    switch (task.status) {
      case TaskStatus.notStarted:
        if (difference == 0) {
          return 'Due Today';
        } else if (difference == 1) {
          return 'Due Tomorrow';
        } else if (difference > 1) {
          return 'Due in ${difference} days';
        } else {
          return 'Overdue - ${difference.abs()}d ${_getTimeOverdue()}';
        }
      case TaskStatus.started:
        if (difference < 0) {
          return 'Overdue - ${difference.abs()}d ${_getTimeOverdue()}';
        } else if (difference == 0) {
          return 'Due Today';
        } else if (difference == 1) {
          return 'Due Tomorrow';
        } else {
          return 'Due in ${difference} days';
        }
      case TaskStatus.completed:
        return 'Completed: ${_formatDate(task.startDate)}';
    }
  }

  String _getTimeOverdue() {
    final now = DateTime.now();
    final difference = now.difference(task.startDate);
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  Color _getStatusColor() {
    final now = DateTime.now();
    final difference = task.startDate.difference(now).inDays;
    final isOverdue = difference < 0 && task.status != TaskStatus.completed;

    if (isOverdue) {
      return Colors.red;
    }

    switch (task.status) {
      case TaskStatus.notStarted:
        return Colors.orange;
      case TaskStatus.started:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  Widget _buildActionButton() {
    switch (task.status) {
      case TaskStatus.notStarted:
        return TextButton(
          onPressed: () => onStatusUpdate(task.id, TaskStatus.started),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayCircleIcon(
                size: 15,
                backgroundColor: Colors.blue,
                iconColor: Colors.white,
                elevation: 0,
              ),
              const SizedBox(width: 6),
              const Text(
                'Start Task',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ],
          ),
        );
      case TaskStatus.started:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, color: Colors.green, size: 16),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => onStatusUpdate(task.id, TaskStatus.completed),
              child: const Text(
                'Mark as complete',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
          ],
        );
      case TaskStatus.completed:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.green, size: 16),
            SizedBox(width: 4),
            Text(
              'Mark as complete',
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      task.id,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue.shade800,
                      ),
                    ),
                    Icon(Icons.more_vert, size: 18, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      task.assignee,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    if (task.priority.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        task.priority,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: task.status != TaskStatus.completed
                        ? () => onEditDeadline(task.id)
                        : null,
                    child: Text(
                      _getStatusText(),
                      style: TextStyle(fontSize: 12, color: _getStatusColor()),
                    ),
                  ),
                  if (task.status == TaskStatus.notStarted ||
                      task.status == TaskStatus.started) ...[
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => onEditDeadline(task.id),
                      child: Icon(
                        Icons.edit_square,
                        size: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              if (task.status == TaskStatus.started) ...[
                Text(
                  'Started: ${_formatDate(DateTime.now())}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 4),
              ],
              _buildActionButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayCircleIcon extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const PlayCircleIcon({
    super.key,
    this.size = 20,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    required int elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      child: Icon(Icons.play_arrow, size: size * 0.6, color: iconColor),
    );
  }
}
