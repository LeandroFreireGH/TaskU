import 'package:flutter/material.dart';
import 'package:test/features/auth/screens/login.dart';
import 'package:test/features/create_tasks/screens/new_task.dart';
import 'package:test/features/modifie_task/screens/modifie_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksList extends StatefulWidget {
  String uid;
  TasksList(this.uid);

  @override
  _TasksListState createState() => _TasksListState(uid);
}

class _TasksListState extends State<TasksList> {
  String uid;
  _TasksListState(this.uid);
  List<String> items = ['Todas', 'Pendientes', 'Realizadas'];
  String selectedItem = 'Todas';

  Stream<QuerySnapshot> getTasksStream() {
    if (selectedItem == 'Todas') {
      return FirebaseFirestore.instance
          .collection('Tareas')
          .where('usuario', isEqualTo: uid)
          .snapshots();
    } else if (selectedItem == 'Pendientes') {
      return FirebaseFirestore.instance
          .collection('Tareas')
          .where('usuario', isEqualTo: uid)
          .where('estado', isEqualTo: false)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Tareas')
          .where('usuario', isEqualTo: uid)
          .where('estado', isEqualTo: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Tareas'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const TaskU()),
                  (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: selectedItem,
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: (item) => setState(() => selectedItem = item!),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getTasksStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final tasks = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final estado = task['estado'] as bool;
                    final titulo = task['titulo'] as String;
                    final fecha = task['fecha'] as String;

                    return ListTile(
                      leading: estado
                          ? CircleAvatar(
                              child: Icon(Icons.check),
                            )
                          : CircleAvatar(
                              child: Icon(Icons.delete),
                            ),
                      title: Text(titulo),
                      subtitle: Text(fecha),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModifieUi(task, uid)),
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskUI(uid)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
