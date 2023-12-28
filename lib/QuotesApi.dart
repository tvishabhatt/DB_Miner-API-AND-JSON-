import 'dart:convert';

import 'package:db_miner_pr7/Favorite.dart';
import 'package:db_miner_pr7/ModalAPI.dart';
import 'package:db_miner_pr7/WallpaperPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class QuotesApi extends StatefulWidget{
  String category_name='';
  QuotesApi({required this.category_name});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return QuotesApiState(category_name);
  }

}
class QuotesApiState extends State<QuotesApi>{

String category_name='';

  QuotesApiState(this.category_name);


final RxList<bool> isFavList = <bool>[].obs;
List<ModalAPI> quotelistformapi=[];
late Database database;



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    openDatabaseAndFetchData();
}
  @override


Future<void> openDatabaseAndFetchData() async {
  database = await openDatabase(
    join(await getDatabasesPath(), 'quotes_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE quotes(id INTEGER PRIMARY KEY AUTOINCREMENT, quote TEXT, author TEXT)',
      );
    },
    version: 1,
  );
  await fetchDataFromAPI();
}
Future<void> deleteAllData() async {
  try {
    await database.delete('quotes');
    print('All data deleted successfully.');
  } catch (error) {
    print('Error deleting data: $error');
  }
}
Future<void> fetchDataFromAPI() async {
  var apiKey = '9PeOWi/rY86tzaUgTTepqA==tUKwHrndNJ06hxsF';

  try {
    for (int i = 0; i < 10; i++) {
      var response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category_name'),
        headers: {'X-API-KEY': apiKey},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as List<dynamic>;

        for (var item in jsonData) {
          ModalAPI modelClass = ModalAPI.fromJson(item);
          quotelistformapi.add(modelClass);
          await database.insert('quotes', {
            'quote':modelClass.quote,
            'author': modelClass.author,

          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    }

    setState(() {});
  } catch (error) {
    print('Error: $error');
  }
}

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Quotes From API",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
        actions: [
          IconButton(onPressed: () async{
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorite()));

          }, icon: Icon(Icons.favorite)),

        ],
      ),
  body:
  ListView.builder(
    itemCount: quotelistformapi.length,
    itemBuilder: (context, index) {

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WallpaperPage(a: quotelistformapi[index].author, q: quotelistformapi[index].quote, c: category_name),));
          },
          child:
          Card(color: Color(0xff80ade5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                    quotelistformapi[index].quote
                ),
                trailing: IconButton(onPressed: () {


                  FavoriteQoutes newfav=FavoriteQoutes(quotes:quotelistformapi[index].quote, category:quotelistformapi[index].category , author:quotelistformapi[index].author);
                  ListoffavQoutesFromJson.add(newfav);
                  print("added in favorite");
                  showFavToast();

                }, icon: Icon(Icons.favorite)) ,
              ),
            ),
          ),
        ),
      );
    },),




    );
  }

}
