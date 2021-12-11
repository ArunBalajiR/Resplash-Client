import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resplash/pages/details.dart';
import 'package:resplash/pages/empty_page.dart';
import 'package:resplash/pages/internet.dart';
import 'package:resplash/widgets/cached_image.dart';

class PopularItems extends StatefulWidget {
  PopularItems({Key? key}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _PopularItemsState createState() => _PopularItemsState();
}

class _PopularItemsState extends State<PopularItems>
    with AutomaticKeepAliveClientMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _data = [];


  Future _getData() async {
    try {
      QuerySnapshot data;
      if (_lastVisible == null)
        data = await firestore
            .collection('contents')
            .orderBy('loves', descending: true)
            .limit(10)
            .get();
      else
        data = await firestore
            .collection('contents')
            .orderBy('loves', descending: true)
            .startAfter([_lastVisible!['loves']])
            .limit(10)
            .get();

      if (data.docs.length > 0) {
        _lastVisible = data.docs[data.docs.length - 1];
        if (mounted) {
          setState(() {
            _isLoading = false;
            _data.addAll(data.docs);
          });
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print(e);
    }
    return _data;
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return (snapshot.data == null)
              ? Center(
                  child: Center(
                    child: new Opacity(
                      opacity: _isLoading ? 1.0 : 0.0,
                      child: new SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: CupertinoActivityIndicator()),
                    ),
                  ),
                )
              : snapshot.data == "error" || snapshot.data.length == 0
                  ? snapshot.data == "error"
                      ? NoInternetPage()
                      : EmptyPage(
                          title: "No wallpapers found",
                          subTitle: "",
                          icon: FontAwesomeIcons.heart)
                  : StaggeredGridView.countBuilder(
                      physics: BouncingScrollPhysics(),
                      controller: controller,
                      crossAxisCount: 4,
                      itemCount: _data.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < _data.length) {
                          final DocumentSnapshot d = _data[index];
                          return InkWell(
                            child: Stack(
                              children: <Widget>[
                                Hero(
                                    tag: 'popular$index',
                                    child: cachedImage(d['thumbnail url'])),
                                Positioned(
                                  bottom: 15,
                                  left: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          d['category'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
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
                                          color: Colors.white.withOpacity(0.5),
                                          size: 25),
                                      Text(
                                        d['loves'].abs().toString(),
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
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
                                            tag: 'popular$index',
                                            imageUrl: d['image url'],
                                            thumbUrl: d['thumbnail url'],
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
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, index.isEven ? 4 : 3),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: EdgeInsets.all(15),
                    );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
