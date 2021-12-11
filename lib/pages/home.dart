import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:resplash/blocs/ads_bloc.dart';
import 'package:resplash/blocs/sign_in_bloc.dart';
import 'package:resplash/pages/search.dart';
import 'package:resplash/utils/dialog.dart';
import '../blocs/data_bloc.dart';
import '../blocs/internet_bloc.dart';
import '../models/config.dart';
import '../pages/bookmark.dart';
import '../pages/catagories.dart';
import '../pages/details.dart';
import '../pages/explore.dart';
import '../pages/internet.dart';
import '../widgets/drawer.dart';
import '../widgets/loading_animation.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int listIndex = 0;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  AdsBloc admobHelper = new AdsBloc();

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 1,
    minLaunches: 3,
    remindDays: 1,
    remindLaunches: 3,
    googlePlayIdentifier: Config().packageName,
  );

  void rateReflix(){
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Rate us in Playstore',
          message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
          rateButton: 'RATE', // The dialog "rate" button text.
          listener: (button) { // The button click listener (useful if you want to cancel the click event).
            switch(button) {
              case RateMyAppDialogButton.rate:
                LaunchReview.launch(
                    androidAppId: Config().packageName,
                    iOSAppId: null,
                    writeReview: true
                );
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          ignoreNativeDialog: Platform.isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: DialogStyle(

                dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                 messagePadding: EdgeInsets.all(10.0),
                titleStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textSelectionTheme.selectionColor,),

          ),
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
  }

  Future getData() async {
    Future.delayed(Duration(milliseconds: 0)).then((f) {
      final sb = context.read<SignInBloc>();
      final db = context.read<DataBloc>();
      sb
          .getUserDatafromSP()
          .then((value) => db.getData())
          .then((value) => db.getCategories());
    });
  }

  Future initAdmobAd() async{
    await MobileAds.instance.initialize();
    context.read<AdsBloc>().loadAdmobInterstitialAd();
  }





  Future _getStoragePermission() async {
    await Permission.storage.request();
  }


  @override
  void initState() {
    super.initState();
    initOneSignal();
    getData();
    rateReflix();
    initAdmobAd();

    _getStoragePermission();
  }

  initOneSignal (){
    OneSignal.shared.setAppId(Config().onesignalAppId);
  }

  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final db = context.watch<DataBloc>();
    final ib = context.watch<InternetBloc>();
    final sb = context.watch<SignInBloc>();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor,
      statusBarColor: Colors.transparent,
        // ignore: deprecated_member_use
        statusBarIconBrightness: Theme.of(context).accentColorBrightness,

    ));

    return Material(
      child: ib.hasInternet == false
        ? NoInternetPage()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).primaryColor,
            drawerScrimColor: Colors.black.withOpacity(0.54),
            endDrawer: DrawerWidget(),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                        left: 30,
                        right: 10,
                      ),
                      alignment: Alignment.centerLeft,
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Text(
                            Config().appName,
                            style: TextStyle(
                                fontSize: 27,
                                color: Theme.of(context).textSelectionTheme.selectionColor,
                                fontWeight: FontWeight.w800,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                  image: !context.watch<SignInBloc>().isSignedIn || context.watch<SignInBloc>().imageUrl == null
                                      ? DecorationImage(image: CachedNetworkImageProvider(Config().guestUserImage))
                                      : DecorationImage(image: CachedNetworkImageProvider(context.watch<SignInBloc>().imageUrl!))),
                            ),
                            onTap: () {
                              !sb.isSignedIn
                                  ? showGuestUserInfo(context)
                                  : showUserInfo(context, sb.name, sb.email, sb.imageUrl,);
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.stream,
                              size: 20,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                        ],
                      ),),
                      Stack(
                        children: <Widget>[
                          CarouselSlider(
                            options: CarouselOptions(
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            initialPage: 0,
                            viewportFraction: 0.90,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            height: h * 0.71,
                            onPageChanged: (int index, reason) {
                              setState(() => listIndex = index);
                            }),
                            items: db.alldata.length == 0 ? [0, 1].take(1).map((f) => LoadingWidget()).toList()
                            : db.alldata.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 0),
                                      child: InkWell(
                                        child: CachedNetworkImage(
                                          imageUrl: i['thumbnail url'],
                                          imageBuilder: (context, imageProvider) => Hero(
                                            tag: i['timestamp'],
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 50,
                                              ),
                                              decoration: BoxDecoration(
                                                  color:Theme.of(context).shadowColor,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color:Theme.of(context).shadowColor,
                                                        blurRadius: 30,
                                                        offset: Offset(5, 20),
                                                    ),
                                                  ],
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:const EdgeInsets.only(left: 20,bottom: 30),
                                                    child: Row(
                                                    crossAxisAlignment:CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                              Material(
                                                                type : MaterialType.transparency,
                                                                child: FittedBox(

                                                                  fit: BoxFit.cover,
                                                                  child : Text(
                                                                    Config().homePageText,
                                                                    style: GoogleFonts.greatVibes(
                                                                      color: Colors.white,
                                                                      fontSize: 25,
                                                                      fontWeight: FontWeight.bold,
                                                                     ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Material(
                                                                type: MaterialType.transparency,
                                                                child: Text(i['category'],
                                                                  style: TextStyle(
                                                                  decoration:TextDecoration.none,
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                 ),
                                                                ),
                                                              ),

                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.favorite,
                                                        size: 25,
                                                        color: Colors.white.withOpacity(0.5),
                                                      ),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        i['loves'].abs().toString(),
                                                        style: TextStyle(
                                                            decoration:TextDecoration.none,
                                                            color: Colors.white.withOpacity(0.7),
                                                            fontSize: 18,
                                                            fontWeight:FontWeight.w600),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                    ],
                                                  ),),
                                            ),
                                          ),
                                          placeholder: (context, url) =>LoadingWidget(),
                                          errorWidget:(context, url, error) => Icon(
                                            Icons.error,
                                            size: 40,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsPage(
                                                tag: i['timestamp'],
                                                thumbUrl: i['thumbnail url'],
                                                imageUrl: i['image url'],
                                                catagory: i['category'],
                                                timestamp: i['timestamp'],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                      ),

                      Positioned(
                        bottom: 1,
                        left: w * 0.34,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: DotsIndicator(
                            dotsCount: 5,
                            position: listIndex.toDouble(),
                            decorator: DotsDecorator(
                              activeColor: Theme.of(context).hintColor,
                              color: Theme.of(context).hintColor,
                              spacing: EdgeInsets.all(3),
                              size: const Size.square(8.0),
                              activeSize: const Size(40.0, 6.0),
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 50,
                    width: w * 0.80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).bottomAppBarColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(FontAwesomeIcons.dashcube,
                              color: Theme.of(context).hintColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatagoryPage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.solidCompass,
                              color: Theme.of(context).hintColor, size: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExplorePage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.solidHeart,
                              color:  Theme.of(context).hintColor, size: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookmarkPage(userUID: context.read<SignInBloc>().uid),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.search,
                              color: Theme.of(context).hintColor, size: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),);
  }
}
