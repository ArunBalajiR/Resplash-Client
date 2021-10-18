import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../pages/details.dart';
import '../widgets/cached_image.dart';


class CatagoryItem extends StatefulWidget {
  final String title;
  final String selectedCatagory;
  CatagoryItem({Key key, @required this.title, this.selectedCatagory})
      : super(key: key);

  @override
  _CatagoryItemState createState() =>
      _CatagoryItemState(this.title, this.selectedCatagory);
}

class _CatagoryItemState extends State<CatagoryItem> {
  String title;
  String selectedCatagory;
  _CatagoryItemState(this.title, this.selectedCatagory);


  

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    _isLoading = true;
    _getData();
    super.initState();
  }


  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;

  List<DocumentSnapshot> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();



  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection('contents')
          .where('category', isEqualTo: selectedCatagory)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    else
      data = await firestore
          .collection('contents')
          .where('category', isEqualTo: selectedCatagory)
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(10)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(data.docs);
        });
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No more posts!',style: TextStyle(color: Colors.grey)),
            backgroundColor: Theme.of(context).bottomAppBarColor,
          )
      );
    }
    return null;
  }

  

  



  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        key: scaffoldKey,
        centerTitle: false,
        title: Text(
          title,
          style: TextStyle(color:Theme.of(context).textSelectionTheme.selectionColor),
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: StaggeredGridView.countBuilder(
              physics: BouncingScrollPhysics(),
              crossAxisCount: 4,
              controller: controller,
              itemCount: _data.length + 1,
              itemBuilder: (BuildContext context, int index) {

              if(index < _data.length){
                final DocumentSnapshot d = _data[index];
                return InkWell(
                child: Stack(
                  children: <Widget>[
                    Hero(
                        tag: 'category$index',
                        child: cachedImage(d['image url'])),

                    Positioned(
                      right: 10,
                      top: 20,
                      child: Row(
                        children: [
                          Icon(Icons.favorite,
                              color: Colors.white.withOpacity(0.5), size: 25),
                          Text(
                            d['loves'].toString(),
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
                                tag: 'category$index',
                                imageUrl: d['image url'],
                                catagory: d['category'],
                                timestamp: d['timestamp'],
                              )));
                },
              );
              }
              return Center(
                      child: new Opacity(
                        opacity: _isLoading ? 1.0 : 0.0,
                        child: new SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CupertinoActivityIndicator()),
                      ),
                    );
                
                
                },
              staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 4 : 3),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.all(15),
            ),
          ),
        ],
      ),
    );
  }
}
