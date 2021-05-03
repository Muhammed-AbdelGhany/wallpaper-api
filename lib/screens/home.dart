import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/models/categories.dart';
import 'package:wallpaper_app/models/photo.dart';
import 'package:wallpaper_app/widgets/category_widget.dart';
import 'package:wallpaper_app/widgets/photos_grid.dart';
import '../models/photo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  Category category = Category();

  List<Photo> photos = [];

  getTrendingWallpapers() async {
    String baseUrl = "https://api.pexels.com/v1/curated?per_page=15";
    Response response = await Dio().get(baseUrl,
        options: Options(headers: {
          "Authorization":
              "563492ad6f91700001000001cad345350b094cecbf9c4deb82377f87"
        }));
    Wallpaper wallpaperData = Wallpaper.fromJson(response.data);
    photos = wallpaperData.photos;

    print(wallpaperData.photos);
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = category.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.symmetric(horizontal: 14),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Search Wallpapers',
                            border: InputBorder.none),
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                height: 80,
                child: ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      return CategoryWidget(
                        imageUrl: categories[i].imageUrl,
                        title: categories[i].categoryName,
                      );
                    }),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                child: ListView.builder(
                    itemCount: photos.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      return PhotosGrid(
                        imageUrl: photos[i].src.portrait,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
