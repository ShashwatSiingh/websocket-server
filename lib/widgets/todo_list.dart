import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (todoProvider.error != null) {
          return Center(child: Text('Error: ${todoProvider.error}'));
        }

        if (todoProvider.todos.isEmpty) {
          return const Center(child: Text('No tasks yet'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todoProvider.todos.length,
          itemBuilder: (context, index) {
            final todo = todoProvider.todos[index];
            return TodoItem(todo: todo);
          },
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  final TodoModel todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id ?? ''),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TodoProvider>(context, listen: false)
            .deleteTodo(todo.id ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${todo.title} deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (bool? value) {
              if (todo.id != null) {
                Provider.of<TodoProvider>(context, listen: false)
                    .toggleTodoStatus(todo.id!, value ?? false);
              }
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Due: ${_formatDate(todo.dueTime)}'),
              const SizedBox(height: 4),
              _buildPriorityChip(todo.priority),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TodoProvider>(context, listen: false)
                  .deleteTodo(todo.id ?? '');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    final color = switch (priority.toLowerCase()) {
      'high' => Colors.red[100]!,
      'medium' => Colors.orange[100]!,
      _ => Colors.green[100]!,
    };

    final textColor = switch (priority.toLowerCase()) {
      'high' => Colors.red[900]!,
      'medium' => Colors.orange[900]!,
      _ => Colors.green[900]!,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}