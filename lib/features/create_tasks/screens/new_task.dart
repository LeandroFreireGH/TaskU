import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/begin/screens/tasks_list.dart';

class TaskUI extends StatefulWidget {
  String uid;
  TaskUI(this.uid);
  @override
  _TaskUI createState() => _TaskUI(uid);
}

class _TaskUI extends State<TaskUI> {
  String uid;
  _TaskUI(this.uid);
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  DateTime selected_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Tarea'),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 130, bottom: 10, right: 10, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controllerTitle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Título',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controllerDescription,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Descripción',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selected_date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (pickedDate != null) {
                  setState(() {
                    selected_date = pickedDate;
                  });
                }
              },
              child: Row(children: [
                Icon(Icons.calendar_today),
                const SizedBox(
                  width: 8,
                ),
                Text(
                    "${selected_date.year} - ${selected_date.month} - ${selected_date.day}"),
              ]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () async {
                String title = _controllerTitle.text;
                String description = _controllerDescription.text;
                try {
                  FirebaseFirestore.instance.collection('Tareas').add({
                    'titulo': title,
                    'descripcion': description,
                    'fecha':
                        "${selected_date.year} - ${selected_date.month} - ${selected_date.day}",
                    'estado': false,
                    'usuario': uid,
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Tarea Creada'),
                      );
                    },
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TasksList(uid)),
                  );
                } catch (e) {
                  final snackBar = SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text("Crear", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
