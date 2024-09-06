import 'dart:convert';
import 'dart:io';

import 'package:cey_go/ui/Navigation%20Bar/navigation_Bar.dart';
import 'package:cey_go/ui/Visa%20Process%20Screen/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VisaScreen extends StatefulWidget {
  @override
  _VisaScreenState createState() => _VisaScreenState();
}

class _VisaScreenState extends State<VisaScreen> {
  void _clearForm() {
    // Add your implementation here
  }

  final FirebaseStorage storage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  String? _selectedChildGender;
  String? _selectedOptionChild;
  String? _imageName = 'Upload Image';
  String? _imageName1 = 'Upload Image';
  final ImagePicker _picker = ImagePicker();
  String? _adultImageBase64;
  String? _passportImageBase64;

  // Text Controllers
  late TextEditingController _adultNameController;
  late TextEditingController _adultDOBDController;
  late TextEditingController _adultDOBMController;
  late TextEditingController _adultDOBYController;
  late TextEditingController _adultNatController;
  late TextEditingController _adultCOBDController;
  late TextEditingController _adultOccController;
  late TextEditingController _adultPNController;
  late TextEditingController _adultPIDDDController;
  late TextEditingController _adultPIDDMController;
  late TextEditingController _adultPIDDYController;
  late TextEditingController _adultPXDDController;
  late TextEditingController _adultPXDMController;
  late TextEditingController _adultPXDYController;
  late TextEditingController _childNameController;
  late TextEditingController _childDOBDController;
  late TextEditingController _childDOBMController;
  late TextEditingController _childDOBYController;
  late TextEditingController _childRelController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingData(); // Load data from Firestore if exists
  }

  void _initializeControllers() {
    _adultNameController = TextEditingController();
    _adultDOBDController = TextEditingController();
    _adultDOBMController = TextEditingController();
    _adultDOBYController = TextEditingController();
    _adultNatController = TextEditingController();
    _adultCOBDController = TextEditingController();
    _adultOccController = TextEditingController();
    _adultPNController = TextEditingController();
    _adultPIDDDController = TextEditingController();
    _adultPIDDMController = TextEditingController();
    _adultPIDDYController = TextEditingController();
    _adultPXDDController = TextEditingController();
    _adultPXDMController = TextEditingController();
    _adultPXDYController = TextEditingController();
    _childNameController = TextEditingController();
    _childDOBDController = TextEditingController();
    _childDOBMController = TextEditingController();
    _childDOBYController = TextEditingController();
    _childRelController = TextEditingController();
  }

  Future<void> _loadExistingData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('visaApplications')
          .doc(firebaseUser.uid)
          .collection('personalInfo')
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        final data = docSnapshot.docs.first.data();
        setState(() {
          _adultNameController.text = data['adultName'] ?? '';
          _adultDOBDController.text = data['adultDOBD'] ?? '';
          _adultDOBMController.text = data['adultDOBM'] ?? '';
          _adultDOBYController.text = data['adultDOBY'] ?? '';
          _adultNatController.text = data['adultNat'] ?? '';
          _adultCOBDController.text = data['adultCOBD'] ?? '';
          _adultOccController.text = data['adultOcc'] ?? '';
          _adultPNController.text = data['adultPN'] ?? '';
          _adultPIDDDController.text = data['adultPIDDD'] ?? '';
          _adultPIDDMController.text = data['adultPIDDM'] ?? '';
          _adultPIDDYController.text = data['adultPIDDY'] ?? '';
          _adultPXDDController.text = data['adultPXDD'] ?? '';
          _adultPXDMController.text = data['adultPXDM'] ?? '';
          _adultPXDYController.text = data['adultPXDY'] ?? '';
          _selectedGender = data['selectedGender'];
          _childNameController.text = data['childName'] ?? '';
          _childDOBDController.text = data['childDOBD'] ?? '';
          _childDOBMController.text = data['childDOBM'] ?? '';
          _childDOBYController.text = data['childDOBY'] ?? '';
          _childRelController.text = data['childRel'] ?? '';
          _selectedChildGender = data['selectedChildGender'];
          _selectedOptionChild = data['selectedOptionChild'];
          _adultImageBase64 = data['adultImageUrl'];
          _passportImageBase64 = data['passportImageUrl'];
          _imageName = _adultImageBase64 != null ? 'Uploaded' : 'Upload Image';
          _imageName1 =
              _passportImageBase64 != null ? 'Uploaded' : 'Upload Image';
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load data: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red.shade400,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }

  Future<void> _pickImage(Function(String) onImagePicked) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Reference storageRef =
          storage.ref().child('images/${pickedFile.path}');
      await storageRef.putFile(File(pickedFile.path));
      final String imageUrl = await storageRef.getDownloadURL();
      setState(() {
        onImagePicked(imageUrl);
      });
    }
  }

  Future<void> _saveDataToFirestore() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        Fluttertoast.showToast(
          msg: "User not authenticated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red.shade400,
          textColor: Colors.white,
          fontSize: 14,
        );
        return;
      }

      final userId = firebaseUser.uid;
      final collectionRef = FirebaseFirestore.instance
          .collection('visaApplications')
          .doc(userId)
          .collection('personalInfo');

      // Check if there is already a document in the 'personalInfo' subcollection
      final existingDocs = await collectionRef.get();

      // Prepare the data to save
      final userData = {
        'adultName': _adultNameController.text,
        'adultDOBD': _adultDOBDController.text,
        'adultDOBM': _adultDOBMController.text,
        'adultDOBY': _adultDOBYController.text,
        'adultNat': _adultNatController.text,
        'adultCOBD': _adultCOBDController.text,
        'adultOcc': _adultOccController.text,
        'adultPN': _adultPNController.text,
        'adultPIDDD': _adultPIDDDController.text,
        'adultPIDDM': _adultPIDDMController.text,
        'adultPIDDY': _adultPIDDYController.text,
        'adultPXDD': _adultPXDDController.text,
        'adultPXDM': _adultPXDMController.text,
        'adultPXDY': _adultPXDYController.text,
        'selectedGender': _selectedGender,
        'childName': _childNameController.text,
        'childDOBD': _childDOBDController.text,
        'childDOBM': _childDOBMController.text,
        'childDOBY': _childDOBYController.text,
        'childRel': _childRelController.text,
        'selectedChildGender': _selectedChildGender,
        'selectedOptionChild': _selectedOptionChild,
        'adultImageUrl': _adultImageBase64,
        'passportImageUrl': _passportImageBase64,
      };

      if (existingDocs.docs.isNotEmpty) {
        // Update the existing document
        final docId =
            existingDocs.docs.first.id; // Use the ID of the existing document
        await collectionRef.doc(docId).update(userData);
        Fluttertoast.showToast(
          msg: "Data updated successfully.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green.shade400,
          textColor: Colors.white,
          fontSize: 14,
        );
      } else {
        // Create a new document
        await collectionRef.add(userData);
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
        msg: "Failed to save data: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red.shade400,
        textColor: Colors.white,
        fontSize: 14,
      );
      print('Failed to save data: $e');
    }
  }

  void _submitForm() async {
    await Future.delayed(Duration(seconds: 5));
    if (_formKey.currentState?.validate() ?? false) {
      _saveDataToFirestore();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressStage('Personal\n    Info', true),
                _buildProgressStage('Contact\n Details', false),
                _buildProgressStage('Travel\n  Info', false),
              ],
            ),
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
                        const Center(
                          child: Text(
                            'Adult Form',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Full name',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: _adultNameController,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                ),
                                hintText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Full Name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Date of Birth',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 140.0),
                              child: Text(
                                'Gender',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultDOBDController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'DD',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'DD';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultDOBMController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'MM',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'MM';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 70,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultDOBYController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'YYYY',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'YYYY';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: ListTileTheme(
                                horizontalTitleGap: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<String>(
                                        value: 'Female',
                                        groupValue: _selectedGender,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedGender = value;
                                          });
                                        },
                                        title: Text(
                                          'Female',
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
                                        value: 'Male',
                                        groupValue: _selectedGender,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedGender = value;
                                          });
                                        },
                                        title: Text(
                                          'Male',
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
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Nationality',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100.0),
                              child: Text(
                                'Country of Birth',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    controller: _adultNatController,
                                    style: TextStyle(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 12),
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      hintText: 'Nationality',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Nationality';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(width: 1.0),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    controller: _adultCOBDController,
                                    style: TextStyle(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 12),
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      hintText: 'Country of Birth',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Country of Birth ';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                        SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Occupation',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: _adultOccController,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                ),
                                hintText: 'Occupation',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Occupation';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Passport Number',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: _adultPNController,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                ),
                                hintText: 'Passport Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Passport Number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Passport Issued Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60.0),
                              child: Text(
                                'Photo',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultPIDDDController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'DD',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'DD';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultPIDDMController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'MM',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'MM';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 70,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultPIDDYController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'YYYY',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'YYYY';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: ElevatedButton(
                                onPressed: () => _pickImage((image) {
                                  setState(() {
                                    _imageName = 'Uploaded';
                                    _adultImageBase64 = image;
                                  });
                                }),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _imageName!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.upload),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Passport Expiry Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60.0),
                              child: Text(
                                'Passport Photo',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultPXDDController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'DD',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'DD';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultPXDMController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'MM',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'MM';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 70,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  controller: _adultPXDYController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                    ),
                                    hintText: 'YYYY',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'YYYY';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: ElevatedButton(
                                onPressed: () => _pickImage((image) {
                                  setState(() {
                                    _imageName1 = 'Uploaded';
                                    _passportImageBase64 = image;
                                  });
                                }),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _imageName1!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.upload),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'If you have a child?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 200),
                          child: ListTileTheme(
                            horizontalTitleGap: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: RadioListTile<String>(
                                    value: 'Yes',
                                    groupValue: _selectedOptionChild,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOptionChild = value;
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
                                Flexible(
                                  child: RadioListTile<String>(
                                    value: 'No',
                                    groupValue: _selectedOptionChild,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedOptionChild = value;
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
                        ),
                        if (_selectedOptionChild == 'No')
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _clearForm,
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Color(0xFF1E1E1E),
                                          shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ).copyWith(
                                          elevation: WidgetStatePropertyAll(0),
                                          shadowColor: WidgetStatePropertyAll(
                                              Colors.transparent),
                                        ),
                                        child: Text('Cancel'),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF1E1E1E),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text('Submit'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Divider(),
                        SizedBox(height: 10),
                        if (_selectedOptionChild == 'Yes')
                          Center(
                            child: Text(
                              'Child Form',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        if (_selectedOptionChild == 'Yes')
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              'Full name',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        SizedBox(height: 5),
                        if (_selectedOptionChild == 'Yes')
                          Padding(
                            padding: EdgeInsets.only(),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: TextFormField(
                                      controller: _childNameController,
                                      style: TextStyle(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                        hintText: 'Full Name',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Child Full Name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Date of Birth',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 140.0),
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: TextFormField(
                                          controller: _childDOBDController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                            ),
                                            hintText: 'DD',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'DD';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: TextFormField(
                                          controller: _childDOBMController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                            ),
                                            hintText: 'MM',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'MM';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    SizedBox(
                                      width: 70,
                                      height: 50,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: TextFormField(
                                          controller: _childDOBYController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                            ),
                                            hintText: 'YYYY',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'YYYY';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: ListTileTheme(
                                        horizontalTitleGap: 1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: RadioListTile<String>(
                                                value: 'Female',
                                                groupValue:
                                                    _selectedChildGender,
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    _selectedChildGender =
                                                        value;
                                                  });
                                                },
                                                title: Text(
                                                  'Female',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                visualDensity: VisualDensity(
                                                    horizontal: -3.0),
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                              ),
                                            ),
                                            Expanded(
                                              child: RadioListTile<String>(
                                                value: 'Male',
                                                groupValue:
                                                    _selectedChildGender,
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    _selectedChildGender =
                                                        value;
                                                  });
                                                },
                                                title: Text(
                                                  'Male',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                visualDensity: VisualDensity(
                                                    horizontal: -3.0),
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Relationship',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: TextFormField(
                                      controller: _childRelController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 12),
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                        hintText: 'Relationship',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide(
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Relationship';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _clearForm,
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Color(0xFF1E1E1E),
                                          shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ).copyWith(
                                          elevation: WidgetStatePropertyAll(0),
                                          shadowColor: WidgetStatePropertyAll(
                                              Colors.transparent),
                                        ),
                                        child: Text('Cancel'),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF1E1E1E),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text('Continue'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStage(String title, bool isActive) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 38.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            // Handle tap here
            print('Circle tapped');
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
              ),
            ),
            child: CircleAvatar(
              radius: 8,
              backgroundColor:
                  isActive ? Color(0xFFC40C0C) : const Color(0xFFFFC100),
            ),
          ),
        )
      ],
    );
  }
}
