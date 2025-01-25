import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import "./login_page.dart";
import "../utils/google_sign_in_provider.dart";
import '../utils/app_images.dart';

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

  late String selectedCollege = "Kalasalingam Academy of Research and Education";
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.get('unitrade.png'),
                  height: 80,
                  width: 80,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "UniTrade",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),

            const Text(
              "Choose your college",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color.fromRGBO(190, 190, 190, 1),
              ),
            ),

            const SizedBox(height: 70),
            
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
                        Color.fromRGBO(220, 220, 220, 0.3),
                        Color.fromRGBO(200, 200, 200, 0.2)
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
                  height: 50,
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
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    collegeTextEditController.clear();
                  }
                },
              ),
            ),


            const SizedBox(height: 50,),

            ElevatedButton(
              onPressed: () {
                if (collegeAndMails[selectedCollege] != null) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(
                        collegeName: selectedCollege,
                        mail: collegeAndMails[selectedCollege]!,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              }, 
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  width: .5,
                  color: Color.fromRGBO(200, 200, 200, .5)
                )
              ),
              child: const Text("Proceed"),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('We will be adding support for more colleges soon!'),
                  ),
                );
              },
              child: const Text(
                "Cannot find your college?",
              ),
            )
          ],
        ),
      ),
    );
  }
}