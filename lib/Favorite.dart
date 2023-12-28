

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Favorite extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
  return FavoriteState();
  }

}
class FavoriteState extends State<Favorite>
{
  @override

  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       title: Text("Favrouites "),

     ),
body: ListoffavQoutesFromJson.isEmpty?
       Center(child: Text('No Favrioutes available')):
    ListView.builder(
      shrinkWrap: true,
    itemCount: ListoffavQoutesFromJson.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text("${ListoffavQoutesFromJson[index].quotes}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),

          subtitle:Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(" - ${ListoffavQoutesFromJson[index].author}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)
            ],
          ),
        ),
      );
    }));
  }

}
List<FavoriteQoutes> ListoffavQoutesFromJson=[];
class FavoriteQoutes{
  final String quotes;
  final String category;
  final String author;

  FavoriteQoutes({required this.quotes, required this.category, required this.author});


  Map<String,dynamic> toMap(){
    return {'quotes':quotes,'category':category,'author':author};
  }
}
void showFavToast() {
  Fluttertoast.showToast(
    msg: "Quote is added  in Favrouites",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
