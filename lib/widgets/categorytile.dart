import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CategoryTile extends StatelessWidget {

  final String imageURL,categoryName;
  final Function redirectTo;
  CategoryTile({this.imageURL,this.categoryName,this.redirectTo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: redirectTo,
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageURL,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.5),
                ),

                child: Text(
                  categoryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
            ),
          ],
        ),
      ),
    );
  }
}
