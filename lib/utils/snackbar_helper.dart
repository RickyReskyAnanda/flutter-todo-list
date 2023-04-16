import 'package:flutter/material.dart';

void statusMessage(
  BuildContext context, {
  required int code,
  required String message,
}) {
  final snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: code != 200 && code != 201
        ? const Color.fromARGB(255, 230, 15, 0)
        : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
