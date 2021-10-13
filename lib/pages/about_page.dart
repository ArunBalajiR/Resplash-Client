import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resplash/models/config.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  final BuildContext navContext;
  About({this.navContext});


  _openPrivacy() async {
    final Uri params = Uri(
      scheme: 'https',
      path: 'casberry-tech.github.io/ReFlix/',
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }




  @override
  Widget build(BuildContext context) {

    aboutAppDialog() {
      showDialog(
          context: context,
          builder: (BuildContext coontext) {

            return AboutDialog(

              applicationVersion: Config().appVersion,
              applicationName: Config().appName,

              applicationIcon: Image(
                height: 40,
                width: 40,
                image: AssetImage(Config().appIcon),
              ),
              applicationLegalese: 'Designed & Developed By CasberryTech Pvt Ltd',
            );
          });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("About"),
      ),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Image.asset(Config().appIcon),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Config().appName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).textSelectionTheme.selectionColor,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "Version : ${Config().appVersion}",
                            style: TextStyle(color : Colors.grey),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Divider(color: Colors.grey.withOpacity(0.5),),
                  SizedBox(height: 10,),
                  Text(
                    "${Config().appName} is being created to provide a new experience in wallpaper application. ${Config().appName} follows a modern, "
                        "easy to use UI but never compromises on the quality of wallpapers. ReSplash provides you with 2D Retouched Wallpapers as well as UHD/4K images from Pexels.com. "
                        "Thanks for downloading the app. Do rate and review. Feel free to send your feedback.",
                    style: TextStyle(color: Colors.blueGrey),
                        
                  ),

                  SizedBox(height: 20,),
                  Text(
                    "Credits",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionTheme.selectionColor.withOpacity(0.7),
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "All the Images shown in this app belongs to their respective owners, this app is just a showcase for users to set wallpapers."
                        "Ads are placed to support myself.Wallpapers listed in this app are either from the public domain or Under creative common license or"
                    ' submitted by the users or provided by the artists themselves or original content made by ${Config().appName} Team. '
                        'If any wallpaper violates any copyright rule then please report it with a screenshot through report button. After proper verification of the'
                    ' ownership, we will take it down.',
                    style: TextStyle(color: Colors.blueGrey),

                  ),
                  SizedBox(height: 20,),
                  Divider(color: Colors.grey.withOpacity(0.5),),
                  InkWell(
                    onTap: () {
                      _openPrivacy();
                    },
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Privacy Policy",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).textSelectionTheme.selectionColor.withOpacity(0.7),
                              fontSize: 20,
                            ),
                          ),

                           Icon(Icons.read_more,size: 28,),

                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.5),),
                  InkWell(
                    onTap: () {
                      aboutAppDialog();
                    },
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Licenses and more",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).textSelectionTheme.selectionColor.withOpacity(0.7),
                              fontSize: 20,
                            ),
                          ),

                          Icon(Icons.more_horiz,size: 28,),

                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.5),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Copyright © 2021",style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                ],
              )),
        ],
      ),
    );
  }
}