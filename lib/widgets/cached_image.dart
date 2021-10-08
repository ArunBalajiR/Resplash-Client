import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../widgets/loading_animation.dart';


  Widget cachedImage(imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 2,
                      offset: Offset(2, 2))
                ],
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover)),
          ),
      placeholder: (context, url) => LoadingWidget1(),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
    );
  }

Widget cachedSearchImage(imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).shadowColor,
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover)),
    ),
    placeholder: (context, url) => LoadingWidget1(),
    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
  );
}

Widget cachedTileImage(imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: 200,
    height: 200,
    fit: BoxFit.cover,
    placeholder: (context, url) => LoadingWidget1(),
    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
  );
}
