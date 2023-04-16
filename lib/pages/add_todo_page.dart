import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learning/components/forms/my_textfield.dart';
import 'package:learning/components/micro/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:learning/services/todo_service.dart';
import 'package:learning/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;

  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
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

  Future<void> submitData() async {
    //submit data ke server
    final success = await TodoService.addTodo(body);
    // menampilkan pesan sukses atau error
    if (success) {
      titleController.text = '';
      descriptionController.text = '';

      // ignore: use_build_context_synchronously
      statusMessage(context, code: 200, message: "To do list created");

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      statusMessage(context, code: 400, message: "Error creation");
    }
  }

  Future<void> updateData() async {
    // mengambil data dari form

    final todo = widget.todo;

    if (todo == null) return;

    final id = todo['_id'];

    //submit data ke server
    final success = await TodoService.updateTodo(id, body);
    // menampilkan pesan sukses atau error
    if (success) {
      // ignore: use_build_context_synchronously
      statusMessage(context, code: 200, message: "To do list updated");

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      statusMessage(context, code: 400, message: "Error updation");
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isEdit ? 'Edit' : 'Add'} Todo List'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 5, left: 25, right: 25),
            child: Text(
              'Title',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
          ),
          MyTextField(
            controller: titleController,
            hintText: 'Title',
            obscureText: false,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 5, left: 25, right: 25),
            child: Text(
              'Description',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: MyTextField(
              controller: descriptionController,
              hintText: 'Description',
              obscureText: false,
              textInputType: TextInputType.multiline,
              minLines: 3,
              maxLines: 5,
            ),
          ),
          MyButton(
              onTap: isEdit ? updateData : submitData,
              text: isEdit ? "Update" : "Save")
        ],
      ),
    );
  }
}
