import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/search_result_screen.dart';

class CategoryWidget extends StatelessWidget {
  final imageUrl;
  final title;
  CategoryWidget({this.imageUrl, this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => SearcResultScreen(
                      queryTitle: title,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black54,
              ),
              width: 120,
              height: 60,
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
