import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/homePage.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add To Do'),
      ),
      body: Form(
          key: formKey,
          child: ListView(padding: const EdgeInsets.all(20), children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 100,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 100,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                addNotes();
                final route = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },
              child: const Text('Add Note'),
            ),
          ]
          )
      ),
    );
  }

  Future<void> addNotes() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {"Content-Type": "application/json"});
  }
}
