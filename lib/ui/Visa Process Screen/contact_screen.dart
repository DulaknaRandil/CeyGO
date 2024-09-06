import 'package:cey_go/ui/Visa%20Process%20Screen/travel_info_screen.dart';
import 'package:cey_go/ui/Visa%20Process%20Screen/visa_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_data.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalController;
  late TextEditingController _countryController;
  late TextEditingController _aisController;
  late TextEditingController _emailOccController;
  late TextEditingController _mnController;

  @override
  void initState() {
    super.initState();
    final formDataC = Provider.of<FormData>(context, listen: false);

    _addressController = TextEditingController(text: formDataC.caddress);
    _cityController = TextEditingController(text: formDataC.ccity);
    _stateController = TextEditingController(text: formDataC.cstate);
    _postalController = TextEditingController(text: formDataC.cpostal);
    _countryController = TextEditingController(text: formDataC.ccountry);
    _aisController = TextEditingController(text: formDataC.cais);
    _emailOccController = TextEditingController(text: formDataC.cemail);
    _mnController = TextEditingController(text: formDataC.cmn);
  }

  void _backForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VisaScreen()),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TravelInfoScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //screen width
    double width = MediaQuery.sizeOf(context).width;

    final formDataC = Provider.of<FormData>(context);
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
                _buildProgressStage('Personal\n    Info', false),
                // _buildDashLines(),
                _buildProgressStage('Contact\n Details', true),
                // _buildDashLines(),
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
                            SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _addressController,
                                  onChanged: (value) {
                                    formDataC.updateCAddress(value);
                                  },
                                  style: TextStyle(
                                      ////color: Colors.black
                                      ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintStyle: TextStyle(
                                      ////color: Colors.black
                                      fontSize: 12,
                                    ),
                                    hintText: 'Address',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        ////color: Colors.black
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the Address';
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
                                'City',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _cityController,
                                  onChanged: (value) {
                                    formDataC.updateCCity(value);
                                  },
                                  style: TextStyle(
                                      ////color: Colors.black
                                      ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintStyle: TextStyle(
                                      ////color: Colors.black
                                      fontSize: 12,
                                    ),
                                    hintText: 'City',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        ////color: Colors.black
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the City';
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
                                'State',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _stateController,
                                  onChanged: (value) {
                                    formDataC.updateCState(value);
                                  },
                                  style: TextStyle(
                                      ////color: Colors.black
                                      ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintStyle: TextStyle(
                                      ////color: Colors.black
                                      fontSize: 12,
                                    ),
                                    hintText: 'State',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        ////color: Colors.black
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the Address';
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
                                    'Zip/Postal Code',
                                    style: TextStyle(
                                      fontSize: 14,
                                      ////color: Colors.black
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 100.0),
                                  child: Text(
                                    'Country',
                                    style: TextStyle(
                                      fontSize: 14,
                                      ////color: Colors.black
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
                                      //width: 200,
                                      height: 50,
                                      child: TextFormField(
                                        controller: _postalController,
                                        onChanged: (value) {
                                          formDataC.updateCPostal(value);
                                        },
                                        style: TextStyle(
                                            ////color: Colors.black
                                            ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                          hintStyle: TextStyle(
                                            //color: Colors.black
                                            fontSize: 12,
                                          ),
                                          hintText: 'Zip/Postal Code',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                                ////color: Colors.black
                                                ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                                ////color: Colors.black
                                                ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                              ////color: Colors.black
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Zip/Postal Code';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // VerticalDivider(width: 1.0),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        controller: _countryController,
                                        onChanged: (value) {
                                          formDataC.updateCCountry(value);
                                        },
                                        style: TextStyle(
                                            ////color: Colors.black
                                            ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 12),
                                          hintStyle: TextStyle(
                                            //color: Colors.black
                                            fontSize: 12,
                                          ),
                                          hintText: 'Country',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                                ////color: Colors.black
                                                ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                12.0), // Adjust the corner radius
                                            borderSide: BorderSide(
                                                ////color: Colors.black
                                                ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                12.0), // Adjust the corner radius
                                            borderSide: BorderSide(
                                              ////color: Colors.black
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Country';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Address in Sri Lanka',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _aisController,
                                  onChanged: (value) {
                                    formDataC.updateCAis(value);
                                  },
                                  style: TextStyle(
                                      ////color: Colors.black
                                      ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintStyle: TextStyle(
                                      ////color: Colors.black
                                      fontSize: 12,
                                    ),
                                    hintText: 'Address in Sri Lanka',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        ////color: Colors.black
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Address in Sri Lanka';
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
                                'Email Address',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _emailOccController,
                                  onChanged: (value) {
                                    formDataC.updateCEmail(value);
                                  },
                                  style: TextStyle(
                                      ////color: Colors.black
                                      ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintStyle: TextStyle(
                                      ////color: Colors.black
                                      fontSize: 12,
                                    ),
                                    hintText: 'Email Address',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        ////color: Colors.black
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the Email Address';
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
                                'Mobile Number',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _mnController,
                                  onChanged: (value) {
                                    formDataC.updateCMn(value);
                                  },
                                  style: TextStyle(
                                      ////color: Colors.black
                                      ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    hintStyle: TextStyle(
                                      ////color: Colors.black
                                      fontSize: 12,
                                    ),
                                    hintText: 'Mobile Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          ////color: Colors.black
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        ////color: Colors.black
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the Mobile Number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width * 0.39,
                                    child: ElevatedButton(
                                      onPressed: _backForm,
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Color(0xFF1E1E1E),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ).copyWith(
                                        elevation: WidgetStatePropertyAll(0),
                                        shadowColor: WidgetStatePropertyAll(
                                            Colors.transparent),
                                      ),
                                      child: Text('Back'),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: width * 0.39,
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
                            ),
                          ])),
                ),
              ),
            ),
            //       SizedBox(height: 20.0),
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
              ////color: Colors.black
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
