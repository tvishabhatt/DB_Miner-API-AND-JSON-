import 'dart:io';
import 'dart:ui' as ui;

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:db_miner_pr7/QuotesJson.dart';
import 'package:db_miner_pr7/Favorite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperPage extends StatelessWidget{

  static GlobalKey wallpaperkey=GlobalKey();
  String q;
  String a;
  String c;
  WallpaperPage({required this.a,required this.q,required this.c});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:
      RepaintBoundary(
        key: wallpaperkey,
        child: Container(
          height: double.infinity,width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image:AssetImage(Img()),fit: BoxFit.cover,
            filterQuality: FilterQuality.high)
          ),
          child:   Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(q,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23,fontFamily: Font()),),
                    SizedBox(height: 30,),
                    ListTile(trailing: Text(" - $a",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23,fontFamily: Font()),),),
                    SizedBox(height: 30,),

                  ],
                ),
              ),
            ),
          ) ,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _setWallpaper(),
        child:Icon(Icons.check,size: 20,) ,
      ),
    );
  }
  void _setWallpaper() async {
    RenderRepaintBoundary boundary =
    wallpaperkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    File tempFile = File(
        '${(await getExternalStorageDirectory())!.path}/screenshot.png');
    await tempFile.writeAsBytes(pngBytes);

    await AsyncWallpaper.setWallpaperFromFile(
        filePath: '${(await getExternalStorageDirectory())!
            .path}/screenshot.png');
    print('Wallpaper set successfully');


      Fluttertoast.showToast(
        msg: "Your wallpaper is Changed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );

  }
}
