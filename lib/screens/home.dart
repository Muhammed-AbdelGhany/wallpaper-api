import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/models/categories.dart';
import 'package:wallpaper_app/models/photo.dart';
import 'package:wallpaper_app/widgets/category_widget.dart';
import 'package:wallpaper_app/widgets/wallpaper-widget.dart';
import '../models/photo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  Category category = Category();
  List<Photo> photos = [];
  bool _isloading = true;

  TextEditingController _textEditingController = TextEditingController();

  getTrendingWallpapers() async {
    String baseUrl = "https://api.pexels.com/v1/curated?per_page=18";
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

  getSearchWallpapers(String searchText) async {
    String baseUrl =
        "https://api.pexels.com/v1/search?query=$searchText&per_page=10";

    setState(() {
      _isloading = true;
    });

    Response response = await Dio().get(baseUrl,
        options: Options(headers: {
          "Authorization":
              "563492ad6f91700001000001cad345350b094cecbf9c4deb82377f87"
        }));
    Wallpaper wallpaperData = Wallpaper.fromJson(response.data);

    setState(() {
      photos = wallpaperData.photos;
      _isloading = false;
    });

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
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            hintText: 'Search Wallpapers',
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          getSearchWallpapers(_textEditingController.text);
                          print(_textEditingController.text);
                        },
                        child: Icon(Icons.search)),
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
              _isloading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
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
                    )
            ],
          ),
        ),
      ),
    );
  }
}
