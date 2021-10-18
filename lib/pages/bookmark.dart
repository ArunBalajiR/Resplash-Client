import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resplash/blocs/sign_in_bloc.dart';
import 'package:resplash/pages/details.dart';
import 'package:resplash/pages/empty_page.dart';
import 'package:resplash/widgets/cached_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/bookmark_bloc.dart';


class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<BookmarkBloc>().getData();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: false,
          title: Text('Saved Items'),
        ),
        body: sb.guestUser == true
            ? EmptyPage(
                icon: FontAwesomeIcons.heart,
                title: 'No wallpapers found.\n Sign in to access this feature',
              )
            : StreamBuilder(
                stream: context.watch<BookmarkBloc>().getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0)
                      return EmptyPage(
                        icon: FontAwesomeIcons.heart,
                        title: 'No wallpapers found',
                      );
                    return _buildList(snapshot);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error),
                    );
                  }

                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildList(snapshot) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        List d = snapshot.data;

        return InkWell(
          child: Stack(
            children: <Widget>[
              Hero(
                  tag: 'bookmark$index',
                  child: cachedImage(d[index]['image url'])),
              Positioned(
                bottom: 15,
                left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      d[index]['category'],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 20,
                child: Row(
                  children: [
                    Icon(Icons.favorite,
                        color: Colors.white.withOpacity(0.5), size: 25),
                    Text(
                      d[index]['loves'].toString(),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsPage(
                          tag: 'bookmark$index',
                          imageUrl: d[index]['image url'],
                          catagory: d[index]['category'],
                          timestamp: d[index]['timestamp'],
                        )));
          },
        );
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 4 : 3),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: EdgeInsets.all(15),
    );
  }
}




