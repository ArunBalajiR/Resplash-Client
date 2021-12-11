import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/src/provider.dart';
import 'package:resplash/pages/empty_page.dart';
import 'package:resplash/pages/internet.dart';
import 'package:resplash/pages/searchdetailpage.dart';
import '../models/config.dart';
import '../widgets/cached_image.dart';
import 'package:resplash/blocs/ads_bloc.dart';
import 'package:http/http.dart' as http;

class SearchItem extends StatefulWidget {
  final String searchKeyword;

  SearchItem({Key? key, required this.searchKeyword})
      : super(key: key);



  @override
  _SearchItemState createState() => _SearchItemState();

}

class _SearchItemState extends State<SearchItem> with AutomaticKeepAliveClientMixin{

  List apikeys=[Config().pexelsKey];
  List<ApiData> data =[];
  List pageIndex= ["1","3","5","7","9"];
  late bool _isLoading;

  Future initAdmobAd() async{
    await MobileAds.instance.initialize();
    context.read<AdsBloc>().loadAdmobInterstitialAd();
  }


  Future getWallPaper()async{

    var url="https://api.pexels.com/v1/search?query=${widget.searchKeyword}&per_page=400&page=${pageIndex[Random().nextInt(pageIndex.length)]}";
    try{
      var apikey =apikeys[Random().nextInt(apikeys.length)];
      await http.get(Uri.parse(url),
          headers:{
            "Authorization" : apikey
          }).timeout(const Duration(seconds: 5)).then((value){

        var decodedJson = jsonDecode(value.body);
        ApiData apiData;
        decodedJson["photos"].forEach((element){
          apiData=ApiData(element["src"]["portrait"]);
          data.add(apiData);
        });
      });
    } on TimeoutException catch(_){
      setState(() {
        _isLoading = false;
      });
      return "error";
    } on SocketException catch(_){
      setState(() {
        _isLoading = false;
      });
      return "error";
    }
    return data;
  }

  @override
  void initState() {
    _isLoading = true;
    initAdmobAd();
    super.initState();
  }



  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        key: scaffoldKey,
        centerTitle: false,
        title: Text(
          widget.searchKeyword.toUpperCase(),
          style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor),
        ),
      ),
      body: FutureBuilder(
        future: getWallPaper(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return (snapshot.data==null) ? Center(child: Center(
            child: new Opacity(
              opacity: _isLoading ? 1.0 : 0.0,
              child: new SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: CupertinoActivityIndicator()),
            ),
          ),):
          snapshot.data == "error" || snapshot.data.length ==0 ?
            snapshot.data == "error" ? NoInternetPage() :EmptyPage(title: "No wallpapers found", subTitle: "Try with different keywords",icon: FontAwesomeIcons.heart)
            : StaggeredGridView.countBuilder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                crossAxisCount: 4,
                staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 4 : 3),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(15),
                itemBuilder: (context, i) {
                  String imgPath = snapshot.data[i].link;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchDetailsPage(
                                tag: 'search$i',
                                catagory: widget.searchKeyword,
                                imageUrl: imgPath,
                                timestamp: DateTime.now().toString(),
                              )));
                    },
                    child: ClipRRect(
                      child: Stack(
                        children: [
                          Hero(
                              child: cachedImage(imgPath),
                              tag: 'search$i',
                          ),
                          Positioned(
                            bottom: 15,
                            right: 20,
                            child: Row(
                              children: [
                                Icon(Icons.favorite,
                                    color: Colors.white.withOpacity(0.5), size: 25),
                                Text(
                                  Random().nextInt(100).toString(),
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
                    ),

                  );

                },);
        },

      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}



class ApiData{
  final String link;
  ApiData(this.link);
}