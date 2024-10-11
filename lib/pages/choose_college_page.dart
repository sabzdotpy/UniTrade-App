import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import "./login_page.dart";
import "../utils/google_sign_in_provider.dart";

class ChooseCollegePage extends StatefulWidget {
  const ChooseCollegePage({super.key});

  @override
  State<ChooseCollegePage> createState() => _ChooseCollegePageState();
}

class _ChooseCollegePageState extends State<ChooseCollegePage> {

  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  final Logger print =  Logger(printer: PrettyPrinter());

  

  final Map<String, String> collegeAndMails = {
    "Kalasalingam Academy of Research and Education" : "klu.ac.in",
    "SRM Institute of Technology": "srm.edu.in"
  };

  late String selectedCollege;
  final TextEditingController collegeTextEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print.i("College Choosing Page Initialized.");
  }

  @override
  void dispose() {
    collegeTextEditController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Choose your college',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: collegeAndMails.keys
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedCollege,
                onChanged: (value) {
                  setState(() {
                    selectedCollege = value!;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(220, 220, 220, 0.2),
                        Color.fromRGBO(200, 200, 200, 0.4)
                      ],
                      transform: GradientRotation(110)
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  )
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: collegeTextEditController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: collegeTextEditController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for your college...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    collegeTextEditController.clear();
                  }
                },
              ),
            ),


            SizedBox(height: 30,),

            ElevatedButton(
              onPressed: () {
                if (collegeAndMails[selectedCollege] != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(collegeName: selectedCollege, mail: collegeAndMails[selectedCollege]!  )),
                  );
                }
              }, 
              child: const Text("Proceed")
            ),
          ],
        ),
      ),
    );
  }
}