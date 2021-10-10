import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resplash/models/config.dart';


class SignInSplash extends StatelessWidget {
  const SignInSplash({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: h,
              width: w,
              color: Colors.black.withOpacity(0),
            ),
            Image(
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              image: AssetImage('assets/images/splashsign.jpg'),

            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.8),
                    Colors.transparent,
                    Colors.black,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            ),
            // Positioned(
            //   left: w / 6,
            //   top: h / 6,
            //   child: Image(
            //     fit: BoxFit.fill,
            //     height: h / 3,
            //     width: w / 1.5,
            //     image: AssetImage(i.img),
            //   ),
            // ),
            Positioned(
                top: h / 1.65,
                child: Container(
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Hi, There , How are you everybody ? ",
                        style: GoogleFonts.rubik(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: h / 1.5,
                child: Container(
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "I'm find. description goes here...",
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )),
            SafeArea(
              child: Row(
                children: <Widget>[
                  Text(
                    Config().appName,
                    style: TextStyle(
                        fontSize: 27,
                        color: Theme.of(context).textSelectionTheme.selectionColor,
                        fontWeight: FontWeight.w800),
                  ),
                  // Image(
                  //   width: w / 3,
                  //   image: AssetImage('assets/netflixlogo.png'),
                  // ),
                  SizedBox(
                    width: w / 2.8,
                  ),
                  Text(
                    'Help  ',
                    style: GoogleFonts.rubik(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    ' Privacy',
                    style: GoogleFonts.rubik(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),

            Positioned(
              top: h/1.1,
              left: w/30,
              child: Container(
                width: w/1.08,
                height: h*0.07,
                color: Colors.red,
                child: FlatButton(onPressed: (){},child: Center(
                  child: Text('SIGN IN',style: GoogleFonts.rubik(
                    fontSize: 24,
                    color: Colors.white,
                  ),),
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
