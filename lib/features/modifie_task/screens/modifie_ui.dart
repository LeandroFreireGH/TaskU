import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/begin/screens/tasks_list.dart';

class ModifieUi extends StatefulWidget {
  QueryDocumentSnapshot<Object?> task;
  String uid;
  ModifieUi(this.task, this.uid);

  @override
  _ModifieUI createState() => _ModifieUI(task, uid);
}

class _ModifieUI extends State<ModifieUi> {
  QueryDocumentSnapshot<Object?> task;
  String uid;
  late TextEditingController _controllerTitle;
  late TextEditingController _controllerDescription;
  late String selected_date;
  late bool isChecked;

  _ModifieUI(this.task, this.uid) {
    _controllerTitle = TextEditingController(text: task['titulo'] ?? '');
    _controllerDescription =
        TextEditingController(text: task['descripcion'] ?? '');
    selected_date = task['fecha'] ?? '';
    isChecked = task['estado'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 145, 193),
        title: const Text('Administrar Tarea'),
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
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (pickedDate != null) {
                  setState(() {
                    selected_date =
                        "${pickedDate.year} - ${pickedDate.month} - ${pickedDate.day}";
                    ;
                  });
                }
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(selected_date),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text('Realizada'),
                Checkbox(
                  value: isChecked,
                  onChanged: (newBool) {
                    setState(() {
                      isChecked = newBool!;
                    });
                  },
                ),
              ],
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
                  await task.reference.update({
                    'titulo': title,
                    'descripcion': description,
                    'fecha': selected_date,
                    'estado': isChecked,
                    'usuario': uid,
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => TasksList(uid)),
                      (route) => false);
                } catch (e) {
                  final snackBar = SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text("Aplicar", textAlign: TextAlign.center),
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
                try {
                  await task.reference.delete();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => TasksList(uid)),
                      (route) => false);
                } catch (e) {
                  final snackBar = SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text("Eliminar", textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
