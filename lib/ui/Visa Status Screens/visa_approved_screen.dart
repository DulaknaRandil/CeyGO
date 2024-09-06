import 'package:flutter/material.dart';

class ApprovedVisaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visa Status'),
      ),
      body: Center(
        child: Text(
          'Congratulations! Your visa application has been approved.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
