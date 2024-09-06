import 'package:flutter/material.dart';

class VisaPendingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visa Status'),
      ),
      body: Center(
        child: Text(
          'Your visa application is pending.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
