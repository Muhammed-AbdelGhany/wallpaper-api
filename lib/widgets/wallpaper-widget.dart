import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/wallpaper_screen.dart';

class WallpaperWidget extends StatelessWidget {
  final imageUrl;
  WallpaperWidget({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => WallpaperScreen(
                      imageUrl: imageUrl,
                    )));
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            child: Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                )),
          )),
    );
  }
}
