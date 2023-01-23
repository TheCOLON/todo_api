import 'package:flutter/material.dart';

class ViewTodo extends StatefulWidget {
  final Map? todo;
  const ViewTodo({required this.todo, Key? key}) : super(key: key);

  @override
  State<ViewTodo> createState() => _ViewTodoState();
}

class _ViewTodoState extends State<ViewTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('View Todo'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
