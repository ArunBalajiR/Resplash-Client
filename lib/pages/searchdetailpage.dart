// details page
import 'dart:ui';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fzwallpaper/fzwallpaper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:resplash/blocs/ads_bloc.dart';
import 'package:share/share.dart';
import 'package:resplash/blocs/sign_in_bloc.dart';
import '../blocs/data_bloc.dart';
import '../blocs/internet_bloc.dart';
import '../models/config.dart';
import '../models/icon_data.dart';
import '../utils/circular_button.dart';

class SearchDetailsPage extends StatefulWidget {
  final String tag;
  final String imageUrl;
  final String catagory;
  final String timestamp;

  SearchDetailsPage(
      {Key key,
        @required this.tag,
        this.imageUrl,
        this.catagory,
        this.timestamp})
      : super(key: key);

  @override
  _SearchDetailsPageState createState() =>
      _SearchDetailsPageState(this.tag, this.imageUrl, this.catagory, this.timestamp);
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {


  String tag;
  String imageUrl;
  String catagory;
  String timestamp;
  _SearchDetailsPageState(this.tag, this.imageUrl, this.catagory, this.timestamp);


  AdsBloc admobHelper = new AdsBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String progress = 'Set as Wallpaper or Download';
  bool downloading = false;
  Stream<String> progressString;
  Icon dropIcon = Icon(Icons.arrow_upward);
  Icon upIcon = Icon(Icons.arrow_upward);
  Icon downIcon = Icon(Icons.arrow_downward);
  Icon heartIcon = LoveIcon().greyIcon;
  bool isPresseed = false;
  PanelController pc = PanelController();
  PermissionStatus status;

  void openSetDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('SET AS'),
          contentPadding:
          EdgeInsets.only(left: 30, top: 40, bottom: 20, right: 40),
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: circularButton(Icons.format_paint, Colors.blueAccent),
              title: Text('Set As Lock Screen'),
              onTap: () async {
                await _setLockScreen();
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: circularButton(Icons.home_filled, Colors.pinkAccent),
              title: Text('Set As Home Screen'),
              onTap: () async {
                await _setHomeScreen();
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: circularButton(Icons.compare, Colors.orangeAccent),
              title: Text('Set As Both'),
              onTap: () async {
                await _setBoth();
                Navigator.pop(context);
              },
            ),

            SizedBox(
              height: 40,
            ),
            Center(
              child: TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }

  //lock screen procedure
  _setLockScreen() {
    Platform.isIOS
        ? setState(() {
      progress = 'iOS is not supported';
    })
        : progressString = Fzwallpaper.imageDownloadProgress(imageUrl);
    progressString.listen((data) {
      setState(() {
        downloading = true;
        progress = 'Setting Your Lock Screen\nProgress: $data';
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      progress = await Fzwallpaper.lockScreen();
      setState(() {
        downloading = false;
        progress = progress;
      });

      openCompleteDialog();
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  // home screen procedure
  _setHomeScreen() {
    Platform.isIOS
        ? setState(() {
      progress = 'iOS is not supported';
    })
        : progressString = Fzwallpaper.imageDownloadProgress(imageUrl);
    progressString.listen((data) {
      setState(() {
        //res = data;
        downloading = true;
        progress = 'Setting Your Home Screen\nProgress: $data';
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      progress = await Fzwallpaper.homeScreen();
      setState(() {
        downloading = false;
        progress = progress;
      });

      openCompleteDialog();
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  // both lock screen & home screen procedure
  _setBoth() {
    Platform.isIOS
        ? setState(() {
      progress = 'iOS is not supported';
    })
        : progressString = Fzwallpaper.imageDownloadProgress(imageUrl);
    progressString.listen((data) {
      setState(() {
        downloading = true;
        progress = 'Setting your Both Home & Lock Screen\nProgress: $data';
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      progress = await Fzwallpaper.bothScreen();
      setState(() {
        downloading = false;
        progress = progress;
      });

      openCompleteDialog();
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  handleStoragePermission() async {
    await Permission.storage.request().then((_) async {
      if (await Permission.storage.status == PermissionStatus.granted) {

        await handleDownload();

      } else if (await Permission.storage.status == PermissionStatus.denied) {
      } else if (await Permission.storage.status == PermissionStatus.permanentlyDenied) {
        askOpenSettingsDialog();
      }
    });
  }




  void openCompleteDialog() async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        title:  'Complete',
        dialogBackgroundColor : Theme.of(context).primaryColor,
        animType: AnimType.SCALE,
        padding: EdgeInsets.all(30),
        body: Center(
          child: Container(
              alignment: Alignment.center,
              height: 80,
              child: Text(
                progress,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
        ),
        btnOkText: 'Ok',
        dismissOnTouchOutside: false,
        btnOkOnPress: () {
          admobHelper.showInterstitialAd();
        }).show();
  }

  askOpenSettingsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Grant Storage Permission to Download'),
            content: Text(
                'You have to allow storage permission to download any wallpaper from this app'),
            contentTextStyle:
            TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            actions: [
              TextButton(
                child: Text('Open Settings'),
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void shareImage() async {
    final ib = context.read<InternetBloc>();
    await context.read<InternetBloc>().checkInternet();
    if(ib.hasInternet == true) {
      setState(() {
        downloading = true;
        progress = 'Sharing your wallpaper is in\nProgress...';
      });
      final response = await get(imageUrl);
      final bytes = response.bodyBytes;
      final Directory temp = await getTemporaryDirectory();
      final File imageFile = File('${temp.path}/$timestamp'+'.jpg');
      imageFile.writeAsBytesSync(bytes);
      Share.shareFiles(['${temp.path}/$timestamp'+'.jpg'], text: 'Wallpaper found on ReSplash\nDownload the app from Playstore.\nGet Unlimited HD Wallpapers for FREE : http://onelink.to/resplash',);
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        downloading = false;
        progress = 'Wallpaper \nShared..❤\n';
      });
    }

  }

  Future handleDownload() async {
    final ib = context.read<InternetBloc>();
    await context.read<InternetBloc>().checkInternet();
    if(ib.hasInternet == true){
      var path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_PICTURES);
      await FlutterDownloader.enqueue(
        url: imageUrl,
        savedDir: path,
        fileName: '${Config().appName}-$catagory$timestamp.jpg',
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );

      setState(() {
        progress = 'Download Complete!\nCheck Your Status Bar';
      });

      await Future.delayed(Duration(seconds: 2));
      openCompleteDialog();

    } else{
      setState(() {
        progress = 'Check your internet connection!';
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final DataBloc db = Provider.of<DataBloc>(context, listen: false);

    return Scaffold(
        key: _scaffoldKey,
        body: SlidingUpPanel(
          controller: pc,
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          minHeight: 120,
          maxHeight: 450,
          backdropEnabled: false,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          body: panelBodyUI(h, w),
          panel: panelUI(db),
          onPanelClosed: () {
            setState(() {
              dropIcon = upIcon;
            });
          },
          onPanelOpened: () {
            setState(() {
              dropIcon = downIcon;
            });
          },
        ));
  }

  // floating ui
  Widget panelUI(db) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).bottomAppBarColor,
                child: dropIcon,
              ),
            ),
            onTap: () {
              pc.isPanelClosed() ? pc.open() : pc.close();
            },
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Config().hashTag,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      '$catagory Wallpaper',
                      style: TextStyle(
                          color:Theme.of(context).textSelectionTheme.selectionColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10,
                                  offset: Offset(2, 2))
                            ]),
                        child: Icon(
                          Icons.format_paint,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () async {
                        final ib =  context.read<InternetBloc>();
                        await context.read<InternetBloc>().checkInternet();
                        if (ib.hasInternet == false) {
                          setState(() {
                            progress = 'Check your internet connection!';
                          });
                        } else{
                          openSetDialog();
                        }

                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Set\n Wallpaper',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textSelectionTheme.selectionColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10,
                                  offset: Offset(2, 2))
                            ]),
                        child: Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        handleStoragePermission();
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Download\n Wallpaper',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textSelectionTheme.selectionColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10,
                                  offset: Offset(2, 2))
                            ]),
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        shareImage();
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Share\nWallpaper',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textSelectionTheme.selectionColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),

              ],
            ),
          ),
          Spacer(),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 5,
                    height: 30,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      progress,
                      style: TextStyle(
                          fontSize: 15,
                          color:Theme.of(context).textSelectionTheme.selectionColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }


  // background ui
  Widget panelBodyUI(h, w) {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    return Stack(
      children: <Widget>[
        Container(
          height: h,
          width: w,
          color: Theme.of(context).shadowColor,
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              ),
              placeholder: (context, url) => Icon(Icons.image),
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.error)),
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: InkWell(
            child: Container(
                height: 40,
                width: 40,
                decoration:
                BoxDecoration(color: Theme.of(context).bottomAppBarColor, shape: BoxShape.circle),
                child: heartIcon),
            onTap: () {
              isPresseed = !isPresseed;
              setState(() {
                isPresseed == true ? heartIcon = LoveIcon().greyIcon : heartIcon = LoveIcon().pinkIcon;
            });
            },
          ),
        ),
        Positioned(
          top: 60,
          left: 20,
          child: InkWell(
            child: Container(
              height: 40,
              width: 40,
              decoration:
              BoxDecoration(color:  Theme.of(context).bottomAppBarColor, shape: BoxShape.circle),
              child: Icon(
                Icons.close,
                size: 25,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

}
