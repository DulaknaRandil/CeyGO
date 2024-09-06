import 'dart:convert';
import 'package:cey_go/ui/Navigation%20Bar/navigation_Bar.dart';
import 'package:cey_go/ui/Visa%20Process%20Screen/travel_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeclarationScreen extends StatefulWidget {
  @override
  _DeclarationScreenState createState() => _DeclarationScreenState();
}

class _DeclarationScreenState extends State<DeclarationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedOption1;
  String? _selectedOption2;
  String? _selectedOption3;

  @override
  void initState() {
    super.initState();
    final formData = Provider.of<FormData>(context, listen: false);
    _selectedOption1 = formData.selopt1;
    _selectedOption2 = formData.selopt2;
    _selectedOption3 = formData.selopt3;
  }

  void _backForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TravelInfoScreen()),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final formData = Provider.of<FormData>(context, listen: false);

      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null) {
          // Convert form data to JSON
          Map<String, dynamic> formDataMap = formData.getAllData();
          String jsonString = jsonEncode(formDataMap);

          await Future.delayed(Duration(seconds: 2));
          // Save JSON data to Firestore
          await _saveDataToFirestore(userId, jsonString);

          // Handle success
          Fluttertoast.showToast(
            msg: "Form submitted successfully.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.green.shade400,
            textColor: Colors.white,
            fontSize: 14,
          );
          print('Form submitted successfully.');
          await Future.delayed(Duration(seconds: 2));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavigationBarScreen()),
          );
        } else {
          Fluttertoast.showToast(
            msg: "User is not logged in.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.red.shade400,
            textColor: Colors.white,
            fontSize: 14,
          );
          print('User is not logged in.');
        }
      } catch (e) {
        // Handle error
        Fluttertoast.showToast(
          msg: "Error submitting form: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red.shade400,
          textColor: Colors.white,
          fontSize: 14,
        );
        print('Error submitting form: $e');
      }
    }
  }

  Future<void> _saveDataToFirestore(String userId, String jsonString) async {
    try {
      final DocumentReference visaApplicantsRef =
          FirebaseFirestore.instance.collection('visa_applicants').doc(userId);

      // Check if the document already exists
      final DocumentSnapshot documentSnapshot = await visaApplicantsRef.get();

      if (documentSnapshot.exists) {
        // If document exists, update it
        await visaApplicantsRef.update({
          'formData': jsonString,
        });
        Fluttertoast.showToast(
          msg: "Data updated successfully.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green.shade400,
          textColor: Colors.white,
          fontSize: 14,
        );
      } else {
        // If document does not exist, create a new one
        await visaApplicantsRef.set({
          'formData': jsonString,
        });

        // Set the status to 1 in the 'visaApprovals' collection
        await FirebaseFirestore.instance
            .collection('visaApprovals')
            .doc(userId)
            .set({
          'status': 1,
        });

        Fluttertoast.showToast(
          msg: "Data saved successfully.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green.shade400,
          textColor: Colors.white,
          fontSize: 14,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error saving data to Firestore: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red.shade400,
        textColor: Colors.white,
        fontSize: 14,
      );
      print('Error saving data to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen width
    double width = MediaQuery.of(context).size.width;

    final formData = Provider.of<FormData>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          backgroundColor: Color(0xFFFFC100),
          toolbarHeight: 90.0,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              SizedBox(height: 5),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFC40C0C),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Visa Application',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color.fromARGB(25, 255, 140, 8),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 140, 8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '1. Do you have a valid residence visa to Sri Lanka? *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ListTileTheme(
                          horizontalTitleGap: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  value: 'Yes',
                                  groupValue: _selectedOption1,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption1 = value;
                                      formData.selopt1 = value;
                                    });
                                  },
                                  title: Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  visualDensity:
                                      VisualDensity(horizontal: -3.0),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  value: 'No',
                                  groupValue: _selectedOption1,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption1 = value;
                                      formData.selopt1 = value;
                                    });
                                  },
                                  title: Text(
                                    'No',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  visualDensity:
                                      VisualDensity(horizontal: -3.0),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '2. Are you currently in Sri Lanka with a valid ETA or obtained an extension of visa? *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTileTheme(
                          horizontalTitleGap: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  value: 'Yes',
                                  groupValue: _selectedOption2,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption2 = value;
                                      formData.selopt2 = value;
                                    });
                                  },
                                  title: Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  visualDensity:
                                      VisualDensity(horizontal: -3.0),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  value: 'No',
                                  groupValue: _selectedOption2,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption2 = value;
                                      formData.selopt2 = value;
                                    });
                                  },
                                  title: Text(
                                    'No',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  visualDensity:
                                      VisualDensity(horizontal: -3.0),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            '3. Do you have a multiple entry visa to Sri Lanka? *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTileTheme(
                          horizontalTitleGap: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  value: 'Yes',
                                  groupValue: _selectedOption3,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption3 = value;
                                      formData.selopt3 = value;
                                    });
                                  },
                                  title: Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  visualDensity:
                                      VisualDensity(horizontal: -3.0),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  value: 'No',
                                  groupValue: _selectedOption3,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOption3 = value;
                                      formData.selopt3 = value;
                                    });
                                  },
                                  title: Text(
                                    'No',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  visualDensity:
                                      VisualDensity(horizontal: -3.0),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: width * 0.9,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFC100),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: width * 0.9,
                            child: ElevatedButton(
                              onPressed: _backForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Back',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
