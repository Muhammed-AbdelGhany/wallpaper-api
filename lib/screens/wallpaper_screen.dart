import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';

class WallpaperScreen extends StatelessWidget {
  final imageUrl;
  WallpaperScreen({this.imageUrl});

  _save() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      print('granted');
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
      print('not');
    }

    var response = await Dio()
        .get(imageUrl, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: randomAlphaNumeric(5));
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(children: [
            Hero(
              tag: imageUrl,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: width / 4,
              right: width / 4,
              child: GestureDetector(
                onTap: () {
                  _save();
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black54, Colors.white54]),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(width: 1, color: Colors.white)),
                  width: 50,
                  height: 60,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Download Wallpaper',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Image will be saved in your gallery',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 25,
                left: width / 4,
                right: width / 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(),
                      child: Text(
                        'Cancle',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ))
          ]),
        ),
      ),
    );
  }
}
