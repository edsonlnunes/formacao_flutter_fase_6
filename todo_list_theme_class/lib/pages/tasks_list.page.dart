import 'package:flutter/material.dart';
import 'package:todo_list_theme_class/pages/config.page.dart';
import 'package:todo_list_theme_class/themes/app_colors.dart';

import '../models/task.model.dart';
import '../routes.dart';
import '../widgets/add_task.widget.dart';
import 'task_detail.page.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  final List<Task> tasks = [];

  void addTask() async {
    final newTask = await showModalBottomSheet<Task>(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const AddTask(),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  void updateTask(Task task, int index) async {
    // final resultUpdate = await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (ctx) => TaskDetailPage(
    //       task: task,
    //     ),
    //   ),
    // );

    final resultUpdate = await Navigator.of(context).pushNamed(
      MyRoutes.taskDetail,
      arguments: task,
    );

    if (resultUpdate != null) {
      setState(() {
        if (resultUpdate is Task) {
          tasks[index] = resultUpdate;
        } else {
          tasks.removeAt(index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarefas"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => ConfigPage(),
              //   ),
              // );
              Navigator.of(context).pushNamed(MyRoutes.configUser);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (ctx, index) {
            final task = tasks[index];

            return Card(
              child: ListTile(
                title: Text(task.title),
                subtitle:
                    task.description != null ? Text(task.description!) : null,
                leading: Checkbox(
                  onChanged: (value) {
                    setState(() {
                      task.changeStatus(value!);
                    });
                  },
                  value: task.completed,
                ),
                trailing: IconButton(
                  icon: Icon(
                    task.important ? Icons.star : Icons.star_border,
                  ),
                  onPressed: () {
                    setState(() {
                      task.changeImportance();
                    });
                  },
                  color: appColors!.primaryColor,
                ),
                onTap: () => updateTask(task, index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addTask,
        label: const Text("Nova tarefa"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
