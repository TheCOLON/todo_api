import 'package:flutter/material.dart';
import "dart:convert";
import 'package:http/http.dart' as http;
import 'package:todo/editTodo.dart';
import 'viewPage.dart';
import 'addTodo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];

  @override
  void initState() {
    getToDo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('To Do'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: getToDo,
        // )
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index] as Map;
            final id = item['_id'] as String;
            return Card(
                child: ListTile(
                  tileColor: Colors.lightBlue[200],
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(child: Text('${index + 1}')),
                  ),
                  title: Text(item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        updatePage(item);
                      } else if (value == 'delete') {
                        deleteById(id);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                          child: Text('Edit'), value: 'edit'),
                      const PopupMenuItem<String>(
                          child: Text('Delete'), value: 'delete'),
                    ],
                  ),
                  onTap: () {
                    viewPage(item);
                  },
                ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTodo(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> viewPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => ViewTodo(todo: item),
    );
    await Navigator.push(context, route);
    getToDo();
  }

  Future<void> updatePage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => EditTodo(todo: item),
    );
    await Navigator.push(context, route);
    getToDo();
  }

  Future<void> deleteById(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {}
  }

  Future<void> getToDo() async {
    final url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map;
    final result = json['items'] as List;

    setState(() {
      items = result;
    });
  }
}
