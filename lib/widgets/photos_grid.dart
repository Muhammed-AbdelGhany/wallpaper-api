import 'package:flutter/material.dart';

class PhotosGrid extends StatelessWidget {
  final imageUrl;
  PhotosGrid({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(imageUrl),
    );
  }
}
