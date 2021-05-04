import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/models/categories.dart';
import 'package:wallpaper_app/models/photo.dart';
import 'package:wallpaper_app/widgets/category_widget.dart';
import 'package:wallpaper_app/widgets/wallpaper-widget.dart';
import '../models/photo.dart';

class SearcResultScreen extends StatefulWidget {
  final queryTitle;
  SearcResultScreen({this.queryTitle});

  @override
  _SearcResultScreenState createState() => _SearcResultScreenState();
}

class _SearcResultScreenState extends State<SearcResultScreen> {
  List<Photo> photos = [];
  bool _isloading = true;

  getTrendingWallpapers() async {
    String car = widget.queryTitle;
    var co = car.toLowerCase();
    String baseUrl = "https://api.pexels.com/v1/search?query=$co&per_page=10";
    Response response = await Dio().get(baseUrl,
        options: Options(headers: {
          "Authorization":
              "563492ad6f91700001000001cad345350b094cecbf9c4deb82377f87"
        }));
    Wallpaper wallpaperData = Wallpaper.fromJson(response.data);
    photos = wallpaperData.photos;
    setState(() {
      _isloading = false;
    });

    print(wallpaperData.photos);
  }

  @override
  void initState() {
    getTrendingWallpapers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 22),
            children: <TextSpan>[
              TextSpan(
                  text: 'Wallpaper',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              TextSpan(
                  text: 'App',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.blue)),
            ],
          ),
        ),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.all(10),
              child: GridView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 1.5),
                itemBuilder: (ctx, i) {
                  return WallpaperWidget(
                    imageUrl: photos[i].src.portrait,
                  );
                },
                itemCount: photos.length,
              ),
            ),
    );
  }
}
