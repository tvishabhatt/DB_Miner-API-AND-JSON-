import 'dart:math';
import 'package:db_miner_pr7/Databasehelper.dart';
import 'package:db_miner_pr7/Favorite.dart';
import 'package:db_miner_pr7/WallpaperPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class QuotesJson extends StatefulWidget{
  final String category;
  QuotesJson({required this.category});
  @override
  State<StatefulWidget> createState() {

    return QuotesJsonState(category);
  }

}
List<String> imglist=['assets/ww1.jpeg','assets/w1.jpg','assets/w2.jpg','assets/w3.jpg','assets/w4.jpg','assets/w5.jpg'];
List<String> fontlist=['SpaceMono','Poppins','PlayfairDisplay'];
class QuotesJsonState extends State<QuotesJson> {
  late String category;
  late QuotesController categoryController;


  QuotesJsonState(this.category) {
    categoryController = QuotesController(category);
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes - $category'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async{
           await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorite(),));

          }, icon: Icon(Icons.favorite)),
        ],
      ),
      body: FutureBuilder(
        future: categoryController.loadQuotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return GetBuilder<QuotesController>(
              init: categoryController,
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.quotes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WallpaperPage(a:controller.quotes[index]['author'] ?? '', q: controller.quotes[index]['quote'] ?? '', c: category),));


                      },
                      title:Card(color: Color(0xff80ade5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                                controller.quotes[index]['quote'] ?? '',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                            ),
                           trailing: IconButton(onPressed: () {


                        FavoriteQoutes newfav=FavoriteQoutes(quotes:controller.quotes[index]['quote'] ?? '', category:category , author:controller.quotes[index]['author'] ?? '');
                        ListoffavQoutesFromJson.add(newfav);
                        print("added in favorite");
                        showFavToast();

                        }, icon: Icon(Icons.favorite)) ,
                          ),
                        ),
                      ),

                  
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

}
String Img(){
  int min=0;
  late final Random random;
  int max=imglist.length-1;
  random=Random();
  int r=min+random.nextInt(max-min);
  String a=imglist[r].toString();
  return a;
}
String Font(){
  int min=0;
  late final Random random;
  int max=fontlist.length-1;
  random=Random();
  int r=min+random.nextInt(max-min);
  String a=fontlist[r].toString();
  print(a);
  return a;
}
class QuotesController extends GetxController{
  final String category;
  List<Map<String,dynamic>> quotes =[];
  QuotesController(this.category);

  @override
  void onInit(){
    super.onInit();
    loadQuotes();
  }
   Future<void>  loadQuotes() async {
    await DataBaseHelper().initializeDatabase();
    List<Map<String, dynamic>> quotesList = await DataBaseHelper().getQuotesByCategory(category);



    print("Quotes List: $quotesList");
   if(quotesList !=null){
     quotes = quotesList;
   }
    update();
  }
}