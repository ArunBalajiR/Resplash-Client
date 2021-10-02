import 'package:flutter/material.dart';
import 'package:resplash/models/config.dart';
import 'package:resplash/widgets/searchpersistent.dart';
import 'package:sliver_fab/sliver_fab.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}



class _SearchPageState extends State<SearchPage> {
  ScrollController controller;
  bool silverCollapsed = false;
  String myTitle = Config().searchPageName;
  TextEditingController t=new TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = ScrollController();

    controller.addListener(() {
      if (controller.offset > 120 && !controller.position.outOfRange) {
        if(!silverCollapsed){
          setState(() {

            myTitle = Config().appName;
            silverCollapsed = true;
          });
        }
      }
      if (controller.offset <= 100 && !controller.position.outOfRange) {
        if(silverCollapsed){
          setState(() {
            myTitle = Config().searchPageName;
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
                  child: Text(
                    myTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                background: Image.network(
                  "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                  fit: BoxFit.cover,
                )),
            pinned: true,
            expandedHeight: 300,
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
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  height: 100,
                  child: Center(
                    child: Text('eee'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
