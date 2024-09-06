import 'package:cey_go/ui/Visa%20Process%20Screen/contact_screen.dart';
import 'package:cey_go/ui/Visa%20Process%20Screen/declaration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_data.dart';

class TravelInfoScreen extends StatefulWidget {
  @override
  _TravelInfoScreenState createState() => _TravelInfoScreenState();
}

class _TravelInfoScreenState extends State<TravelInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedOption;

  late TextEditingController _travelHisController;
  late TextEditingController _reqDaysController;
  late TextEditingController _iADDController;
  late TextEditingController _iADMController;
  late TextEditingController _iADYController;
  late TextEditingController _pOVController;
  late TextEditingController _fNoController;

  @override
  void initState() {
    super.initState();
    final formData = Provider.of<FormData>(context, listen: false);

    _travelHisController = TextEditingController(text: formData.travelHis);
    _reqDaysController = TextEditingController(text: formData.reqDays);
    _iADDController = TextEditingController(text: formData.iADD);
    _iADMController = TextEditingController(text: formData.iADM);
    _iADYController = TextEditingController(text: formData.iADY);
    _pOVController = TextEditingController(text: formData.pOV);
    _fNoController = TextEditingController(text: formData.fNo);
    _selectedOption = formData.Opt;
  }

  void _backForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactScreen()),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DeclarationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //screen width
    double width = MediaQuery.sizeOf(context).width;

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
                _buildProgressStage('Contact\n Details', false),
                // _buildDashLines(),
                _buildProgressStage('Travel\n  Info', true),
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
                                'Where have you been during the last 14 days before this travel',
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
                                  controller: _travelHisController,
                                  onChanged: (value) {
                                    formData.updateTravelHis(value);
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
                                    hintText: '',
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
                                      return 'Please fill the field';
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
                                    'Visa Required Days',
                                    style: TextStyle(
                                      fontSize: 14,
                                      ////color: Colors.black
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 70.0),
                                  child: Text(
                                    'Intended Arrival Date',
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
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: TextFormField(
                                      controller: _reqDaysController,
                                      onChanged: (value) {
                                        formData.updateReqDays(value);
                                      },
                                      keyboardType: TextInputType.number,
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
                                        hintText: 'Visa Required Days',
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
                                          return 'Please fill the field';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      controller: _iADDController,
                                      onChanged: (value) {
                                        formData.updateIAdd(value);
                                      },
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                          ////color: Colors.black
                                          fontSize: 12,
                                        ),
                                        hintText: 'DD',
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
                                          return 'DD';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      controller: _iADMController,
                                      onChanged: (value) {
                                        formData.updateIAdm(value);
                                      },
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                          ////color: Colors.black
                                          fontSize: 12,
                                        ),
                                        hintText: 'MM',
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
                                          return 'MM';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: 70,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      controller: _iADYController,
                                      onChanged: (value) {
                                        formData.updateIADY(value);
                                      },
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: TextStyle(
                                          ////color: Colors.black
                                          fontSize: 12,
                                        ),
                                        hintText: 'YYYY',
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
                                          return 'YYYY';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Purpose of Visit',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _pOVController,
                                  onChanged: (value) {
                                    formData.updatePOV(value);
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
                                    hintText: 'Purpose of Visit',
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
                                      return 'Please fill the field';
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
                                'Port of Departure',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedOption,
                                  hint: Text('  Port of Departure'),
                                  icon: Icon(Icons.arrow_downward),
                                  underline: Container(
                                    width: 10,
                                    height: 2,
                                  ),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                  items: <String>[
                                    'Apia',
                                    'Pago Pago',
                                    'Sao Tome'
                                        'Al Khuraibah',
                                    'Dammam',
                                    'Jeddah',
                                    'Makkah',
                                    'Riyadh',
                                    'Taif',
                                    'Tabuk',
                                    'Abidjan',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedOption = newValue;
                                      formData.Opt = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Flight/Vessel Number',
                                style: TextStyle(
                                    fontSize: 14,
                                    ////color: Colors.black
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _fNoController,
                                  onChanged: (value) {
                                    formData.updateFNo(value);
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
                                    hintText: 'Flight/Vessel Number',
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
                                      return 'Please fill the field';
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
