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



class BookmarkPage extends StatefulWidget {
  BookmarkPage({Key? key, required this.userUID}) : super(key: key);
  final String? userUID;

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {


  Future<List> _getData (List bookmarkedList)async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('uid');

    final DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(_uid);
    DocumentSnapshot snap = await ref.get();

    print('main list: ${bookmarkedList.length}]');

    List d = [];

    if(bookmarkedList.length <= 10){
      await FirebaseFirestore.instance
          .collection('contents')
          .where('timestamp', whereIn: bookmarkedList)
          .get()
          .then((QuerySnapshot snap) {
        d.addAll(snap.docs);
      });

    }else if(bookmarkedList.length > 10){

      int size = 10;
      var chunks = [];

      for(var i = 0; i< bookmarkedList.length; i+= size){
        var end = (i+size<bookmarkedList.length)?i+size:bookmarkedList.length;
        chunks.add(bookmarkedList.sublist(i,end));
      }

      await FirebaseFirestore.instance
          .collection('contents')
          .where('timestamp', whereIn: chunks[0])
          .get()
          .then((QuerySnapshot snap) {
        d.addAll(snap.docs);
      }).then((value)async{
        await FirebaseFirestore.instance
            .collection('contents')
            .where('timestamp', whereIn: chunks[1])
            .get()
            .then((QuerySnapshot snap) {
          d.addAll(snap.docs);
        });
      });

    }else if(bookmarkedList.length > 20){

      int size = 10;
      var chunks = [];

      for(var i = 0; i< bookmarkedList.length; i+= size){
        var end = (i+size<bookmarkedList.length)?i+size:bookmarkedList.length;
        chunks.add(bookmarkedList.sublist(i,end));
      }

      await FirebaseFirestore.instance
          .collection('contents')
          .where('timestamp', whereIn: chunks[0])
          .get()
          .then((QuerySnapshot snap) {
        d.addAll(snap.docs);
      }).then((value)async{
        await FirebaseFirestore.instance
            .collection('contents')
            .where('timestamp', whereIn: chunks[1])
            .get()
            .then((QuerySnapshot snap) {
          d.addAll(snap.docs);
        });
      }).then((value)async{
        await FirebaseFirestore.instance
            .collection('contents')
            .where('timestamp', whereIn: chunks[2])
            .get()
            .then((QuerySnapshot snap) {
          d.addAll(snap.docs);
        });
      });

    }

    return d;

  }




  @override
  Widget build(BuildContext context) {
    final String _collectionName = 'users';
    final String _snapText = 'loved items';

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        title: Text('Saved Items'),
      ),
      body: context.read<SignInBloc>().guestUser == true || widget.userUID == null
          ? EmptyPage(
        icon: FontAwesomeIcons.heart,
        title: 'No wallpapers found.\n Sign in to access this feature',

      ) : StreamBuilder(
        stream: FirebaseFirestore.instance.collection(_collectionName).doc(widget.userUID!).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (!snap.hasData) return CupertinoActivityIndicator();
          List bookamrkedList = snap.data[_snapText];
          return FutureBuilder(
              future: _getData(bookamrkedList),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData){
                  return Center(child: CupertinoActivityIndicator());
                }else if (snapshot.hasError){
                  return Center(child: Text('Error'),);
                }else if (snapshot.hasData && snapshot.data.length == 0){
                  return EmptyPage(icon: FontAwesomeIcons.heart,title: 'No wallpapers found',);
                }else{
                  return _buildList(snapshot);
                }

              });
        },
      ),
    );
  }

  Widget _buildList(snapshot) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      physics: BouncingScrollPhysics(),
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        List d = snapshot.data;

        return InkWell(
          child: Stack(
            children: <Widget>[
              Hero(
                  tag: 'bookmark$index',
                  child: cachedImage(d[index]['thumbnail url'])),
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
                      thumbUrl: d[index]['thumbnail url'],
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