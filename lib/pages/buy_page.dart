import 'package:flutter/material.dart';
import 'package:test_flutter/utils/AppImages.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final TextEditingController searchController = TextEditingController();
  
  final ButtonStyle categoriesButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
    foregroundColor: Colors.white,
    elevation: 0,
    minimumSize: Size.zero,
    padding: const EdgeInsets.fromLTRB(7, 5, 10, 5),
    textStyle: const TextStyle(
      fontSize: 12
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Color.fromRGBO(255, 255, 255, .2), width: 1)
    ),
  );


  static List<Map> buyPageItems = [
    { 'title': 'Arduino UNO', 'imageURL': Appimages.get("arduino.png"), 'description': 'new arduino uno 5V unused, good condition and original brand.', 'rating': 5.0, 'price': 600, 'postedAt': '50 mins ago' },
    { 'title': 'dos', 'description': 'Lorem ipsum', 'rating': 4.0, 'price': 299, 'postedAt': '2 mins ago' },
    { 'title': 'tres', 'description': 'Lorem ipsum', 'rating': 4.0, 'price': 299, 'postedAt': '2 mins ago' },
    { 'title': 'cuatro', 'description': 'Lorem ipsum', 'rating':  4.0,'price': 299, 'postedAt': '2 mins ago' },
  ];

   void _showToast(String message) {
    print("Showing toast.");
  }

  void _onSubmitted(String value) {
    final modifiedText = '$value>'; // Modify the text by adding ">"
    _showToast(modifiedText); // Show the toast with the modified text
  }

  void sayHi() {
    _showToast("Hello there!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onSubmitted: _onSubmitted, // Callback for when the user presses "Done"
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Color.fromARGB(150, 255, 255, 255),),
              contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(200, 180, 232, 252), width: 1.0), // Border color when focused
                borderRadius: BorderRadius.circular(12.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0), // Border color when error occurs
                borderRadius: BorderRadius.circular(12.0),
              ),
             focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0), // Focused border when there's an error
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              hintStyle: const TextStyle(color: Color.fromARGB(150, 255, 255, 255), fontSize: 14, fontWeight: FontWeight.w400),
              hintText: "search by product, or categories...",
              fillColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child:
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: [
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: const Row(
                        children: [SizedBox(width: 6,), Text('All Categories'), Icon(Icons.arrow_drop_down_sharp)],
                      )
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: const Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('IOT Components')],
                      )
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: const Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Mobile Accessories')],
                      )
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: const Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Desktop Peripherals')],
                      )
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: const Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Daily Essentials')],
                      )
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: const Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Headphones')],
                      )
                    ),
                    const SizedBox(width: 10,),
                  ]
                ),
              ),
        ),
        Expanded(child: Container(
          width:  MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(6, 10, 5, 7),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            itemCount: buyPageItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric( vertical: 5 ),
                child: 
                  BuyPageItem(
                    title: buyPageItems[index]['title'],
                    description: buyPageItems[index]['description'],
                    imageURL: buyPageItems[index]['imageURL'],
                    rating: buyPageItems[index]['rating'],
                    price: buyPageItems[index]['price'],
                    postedAt: buyPageItems[index]['postedAt'],
                  ),
              );
            },
          ),
        ) )
      ],)
      ));
  }
}

class BuyPageItem extends StatelessWidget {
  String title;
  String description;
  String? imageURL;
  double rating;
  int price;
  String postedAt;

  BuyPageItem({
    required this.title,
    required this.description,
    this.imageURL,
    required this.rating,
    required this.price,
    required this.postedAt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,  // Full width
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color.fromRGBO(255, 255, 255, .1),
      ),
      child: Row(
        children: [
          // Image Section
          Container(
            foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [ Colors.transparent,Color.fromARGB(255, 20, 20, 20)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 1],
                ),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                imageURL ?? Appimages.get('image-placeholder.jpg'),
                width: 85,
                height: 85,
                fit: BoxFit.contain
              )
            ),
          ),
          SizedBox(width: 10), 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: BuyPageItemSplitter(),
            )),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Daily Essentials",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(.4)
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      postedAt,
                      style: TextStyle(fontSize: 10, 
                      color: Colors.white.withOpacity(.4)),
                    ),
                  ],
                ),
                SizedBox(height: 3,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 93, 19),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 12,),
                          const SizedBox(width: 2,),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ]
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    description,
                    style: const TextStyle(
                        fontSize: 10, 
                        color: Color.fromRGBO(255, 155, 0, 1),
                      ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuyPageItemSplitter extends StatelessWidget {
  const BuyPageItemSplitter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 1.5,
      height: 10,
    );
  }
}
