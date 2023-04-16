import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/pages/add_todo_page.dart';
import 'package:http/http.dart' as http;
import 'package:learning/services/todo_service.dart';
import 'package:learning/utils/snackbar_helper.dart';
import 'package:learning/widget/todo_card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );

    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });

    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(
        todo: item,
      ),
    );

    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });

    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final result = await TodoService.fetchTodo();

    if (result != null) {
      setState(() {
        items = result;
      });
    } else {
      statusMessage(context, code: 400, message: 'Tidak dapat memuat data');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final item = items.singleWhere((e) => e['_id'] == id);

    final success = await TodoService.deleteById(id);

    if (success) {
      // ignore: use_build_context_synchronously
      statusMessage(context, code: 200, message: "${item['title']} dihapus");
      fetchTodo();
    } else {
      // ignore: use_build_context_synchronously
      statusMessage(context,
          code: 400, message: "${item['title']} gagal dihapus");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Todo List"),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Todo'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.blueGrey,
          ),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No Todo Item",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;

                return TodoCard(
                  index: index,
                  item: item,
                  navigateEdit: navigateToEditPage,
                  deleteById: deleteById,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
