import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resplash/models/config.dart';
import 'package:resplash/pages/sign_in_page.dart';
import 'package:resplash/utils/next_screen.dart';

void openDialog(context, title, message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          title: Text(title),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'))
          ],
        );
      });
}

showUserInfo(context, name, email, imageUrl) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape : RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          contentPadding:
              EdgeInsets.only(left: 0, right: 0, top: 40, bottom: 0),
          backgroundColor: Theme.of(context).primaryColor,
          content: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(imageUrl))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Hi $name,',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textSelectionTheme.selectionColor),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'You have alredy signed in with\n$email',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Spacer(),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight:Radius.circular(16) ),
                        color: Colors.blue[400],
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,

                      child: Text(
                        'Ok, Got It',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )),
        );
      });
}



showGuestUserInfo(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape : RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          contentPadding:
              EdgeInsets.only(left: 0, right: 0, top: 40, bottom: 0),
          backgroundColor: Theme.of(context).primaryColor,
          content: Container(
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).shadowColor,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(Config().guestUserImage))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Hi there,',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textSelectionTheme.selectionColor),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      "You didn't sign in with ${Config().appName} yet. Sign in to unlock likes and save feature.\n\nDo you want to sign in now?",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textSelectionTheme.selectionColor.withOpacity(0.7)),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(16) ),
                              color: Colors.blueAccent,
                            ),
                            alignment: Alignment.center,

                            child: Text(
                              'Yes, Now',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            nextScreenPopup(context, SignInPage(closeDialog: true,));
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.only(bottomRight: Radius.circular(16) ),
                              color:Theme.of(context).bottomAppBarColor,
                            ),
                            alignment: Alignment.center,

                            child: Text(
                              'Maybe Later',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      });
}
