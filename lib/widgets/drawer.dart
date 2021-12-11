import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:launch_review/launch_review.dart';
import 'package:resplash/blocs/sign_in_bloc.dart';
import 'package:resplash/pages/about_page.dart';
import 'package:resplash/pages/signin_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/config.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:resplash/models/dark_theme_provider.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var textCtrl = TextEditingController();

  _sendReport() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'info@casberry.tech',
      query: 'subject=Report&body=App Version ${Config().appVersion}', //add subject and body here
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _requestHttp(String urlstr) async {
    final Uri params = Uri(
      scheme: 'https',
      path: urlstr,
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future openLogoutDialog(context1) async{
    showDialog(
      context: context1,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Logout?', style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textSelectionTheme.selectionColor,
          ),),
          content: Text('Do you really want to Logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                final sb = context.read<SignInBloc>();
                Navigator.pop(context);
                sb.userSignout().then((_) => nextScreenCloseOthers(context, SignInPage()));
                

              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );

  }

  Future openReportDialog(context1) async{
    showDialog(
        context: context1,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Row(
              children : [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.report_problem,color: Theme.of(context).textSelectionTheme.selectionColor,size: 30,),
                ),
                SizedBox(width: 0.8,),
                Expanded(
                  child: Text('Report Wallpaper', style: TextStyle(

                    color: Theme.of(context).textSelectionTheme.selectionColor,
                ),


              ),),],
            ),
            content: Text('Wallpapers listed in this app are either from the public domain or Under creative common license or'
                ' submitted by the users or provided by the artists themselves or original content made by ${Config().appName} Team. '
                'If any wallpaper violates any copyright rule then please report it with a screenshot.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Report'),
                onPressed: () {
                  _sendReport();
                },
              ),

            ],
          );
        }
    );

  }










  void handleRating () {
    LaunchReview.launch(
      androidAppId: Config().packageName,
      iOSAppId: null,
      writeReview: true
    );
  }

  void handleLanuch () {
    Share.share(
        'Check out ${Config().appName}, this wallpaper app is really cool! http://onelink.to/reflix',
        subject:'Get Unlimited HD Wallpapers for FREE.\nDownload the app from Playstore http://onelink.to/reflix');

  }



  
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:28.0,bottom: 18.0),
            child: Container(
              height: 100,
              width:  double.infinity,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      alignment: Alignment.center,
                      fit: BoxFit.fitHeight,
                      image:  AssetImage(Config().splashIcon)
                  )
              ),),),

                Text(
                  Config().appName,
                  style: TextStyle(
                      fontSize: 27,
                      color: Theme.of(context).textSelectionTheme.selectionColor,
                      fontWeight: FontWeight.w800),
                ),

                Expanded(
                  child: ListView(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        value: themeChange.darkTheme,
                        secondary:Icon(Icons.dark_mode,color: Colors.grey,),
                        onChanged: (value) {
                          setState(() {
                            themeChange.darkTheme = value;
                          });
                        },
                        title: Text('Dark theme'),
                      ),
                      Divider(color: Colors.grey.withOpacity(0.5),),
                      DrawerTile(
                        icons: FontAwesomeIcons.info,
                        title: "About App",
                        onTaps: (){
                          nextScreeniOS(context, About());
                        },
                      ),
                      Divider(color: Colors.grey.withOpacity(0.5),),
                      DrawerTile(
                        icons: FontAwesomeIcons.share,
                        title: "Share App",
                        onTaps: (){
                          handleLanuch();
                        },
                      ),
                      Divider(color: Colors.grey.withOpacity(0.5),),
                      DrawerTile(
                        icons: FontAwesomeIcons.star,
                        title: "Rate & Review",
                        onTaps: (){
                          handleRating();
                        },
                      ),
                      Divider(color: Colors.grey.withOpacity(0.5),),
                      DrawerTile(
                        icons: Icons.report_problem,
                        title: "Report",
                        onTaps: (){
                          openReportDialog(context);
                        },
                      ),



                    ],
                  ),
                ),
                Column(
                  children: [
                    !context.watch<SignInBloc>().isSignedIn
                    ? Container()
                    : Column(
                      children: [
                        Divider(color: Colors.grey.withOpacity(0.5),),
                        InkWell(
                                child: Container(
                                  height: 45,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.signOutAlt,
                                          color: Colors.grey,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(

                                          'Logout',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  openLogoutDialog(context);
                                },
                              ),
                        SizedBox(height: 20,),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(FontAwesomeIcons.instagram),
                                onPressed: () => _requestHttp('instagram.com/_u/reflix_walls/'),
                              ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.facebook),
                                onPressed: () => _requestHttp('facebook.com/reflixwalls/'),
                              ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.twitter),
                                onPressed: () => _requestHttp('twitter.com/Reflix_walls'),
                              ),
                              IconButton(
                                icon: Icon(FontAwesomeIcons.pinterest),
                                onPressed: () => _requestHttp('pinterest.com/reflix_walls/'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Version : ${Config().appVersion}",style: TextStyle(
                            color:Colors.grey.shade500,
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            )),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.icons,
    required this.title,
    required this.onTaps,
  }) : super(key: key);

  final IconData? icons;
  final String? title;
  final VoidCallback? onTaps;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: <Widget>[
              Icon(
                icons,
                color: Colors.grey,
                size: 22,
              ),
              SizedBox(
                width: 20,
              ),
              Text(

                  title!,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400))
            ],
          ),
        ),
      ),
      onTap: onTaps,
    );
  }
}

