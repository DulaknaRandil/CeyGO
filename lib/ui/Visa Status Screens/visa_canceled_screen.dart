import 'package:flutter/material.dart';

class VisaNotApprovedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visa Status'),
      ),
      body: Center(
        child: Text(
          'Unfortunately, your visa application was not approved.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
