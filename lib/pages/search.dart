import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:resplash/models/config.dart';
import 'package:resplash/widgets/categorytile.dart';
import 'package:resplash/widgets/searchpersistent.dart';
import 'package:sliver_fab/sliver_fab.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}



class _SearchPageState extends State<SearchPage> {
  ScrollController controller;
  Widget initTitle = Text(
    Config().searchPageName,
    style: TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
  );
  bool silverCollapsed = false;
  // String myTitle = Config().searchPageName;
  TextEditingController t=new TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = ScrollController();

    controller.addListener(() {
      if (controller.offset > 120 && !controller.position.outOfRange) {
        if(!silverCollapsed){
          setState(() {

            initTitle = Text(
              Config().appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
            silverCollapsed = true;
          });
        }
      }
      if (controller.offset <= 100 && !controller.position.outOfRange) {
        if(silverCollapsed){
          setState(() {
            initTitle =  Text(
              Config().searchPageName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            );
            silverCollapsed = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          SliverAppBar(

            elevation: 0,
            automaticallyImplyLeading : false,
            flexibleSpace: FlexibleSpaceBar(

                centerTitle: true,
                titlePadding: EdgeInsets.only(bottom: 50),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0,top: 30.0,left: 20,right: 10),
                  child: initTitle,
                ),

                background: CustomPaint(
                  foregroundPainter: FadingEffect(),
                  child:Image.network(
                    "https://github.com/ArunBalajiR/Flutter-Chat-Application/blob/main/images/cover.jpg?raw=true",
                    fit: BoxFit.cover,
                  ),
                ),
            ),
            pinned: true,
            expandedHeight: 400,
            centerTitle: true,
            bottom: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)
                  )
              ),
              toolbarHeight: 75,
              elevation:0,
              automaticallyImplyLeading : false,
              title: Container(
                child: Card(

                  color:Color.fromARGB(255, 40, 63, 77),
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.16,
                    height: MediaQuery.of(context).size.height/17,
                    child: Center(
                      child: TextField(
                        controller: t,
                        onSubmitted:(value) {

                        },
                        style: TextStyle(color:Colors.white70),
                        decoration: InputDecoration(prefixIcon: Icon(Icons.search,color:Colors.white70,),
                          hintText: "Search wallpaper type etc..",border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white70,
                              fontSize: 16),),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Text("The Color tone",style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0),
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ColorWidget(colorName: Colors.black87,),
                  ColorWidget(colorName: Colors.grey,),
                  ColorWidget(colorName: Colors.red,),
                  ColorWidget(colorName: Colors.blue,),
                  ColorWidget(colorName: Colors.green,),
                  ColorWidget(colorName: Colors.amber),
                  ColorWidget(colorName: Colors.pink,),
                  ColorWidget(colorName: Colors.teal,),



                ],

              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(right: 20.0,left: 20.0),
              child: Text("Categories",style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              height: 900.0,
              child: GridView.count(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),

                children: [
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                  CategoryTile(categoryName: "Nature",imageURL: 'https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg',),
                ],
              ),


            ),
          ),

        ],
      ),
    );
  }
}

class ColorWidget extends StatelessWidget {
  final Color colorName;
  final url;
  const ColorWidget({
    Key key,
    this.colorName,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(

      borderRadius: BorderRadius.all(Radius.circular(20)),
      onTap: () {

      },
      child: Container(margin: EdgeInsets.all(12), height: 60, width: 60,decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)), color: colorName,
      ),),
    );
  }
}

class _Search extends StatefulWidget {
  _Search({Key key}) : super(key: key);

  @override
  __SearchState createState() => __SearchState();
}

class __SearchState extends State<_Search> {
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 5),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _editingController,
              // textAlignVertical: TextAlignVertical.center,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.5)),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          _editingController.text.trim().isEmpty
              ? IconButton(
                  icon: Icon(Icons.search,
                      color: Theme.of(context).primaryColor.withOpacity(0.5)),
                  onPressed: null)
              : IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.clear,
                      color: Theme.of(context).primaryColor.withOpacity(0.5)),
                  onPressed: () => setState(
                    () {
                      _editingController.clear();
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
