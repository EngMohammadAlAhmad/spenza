// error_page.dart
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String? message;
  const ErrorPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(
          message == null
              ? 'Unknown routing error'
              : 'Routing error:\n$message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
