import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:provider/provider.dart';
import '../blocs/internet_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../models/config.dart';
import '../pages/home.dart';
import '../utils/next_screen.dart';
import '../utils/snacbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key, this.closeDialog}) : super(key: key);
  final bool closeDialog;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  handleGuestUser() async {
    final sb = context.read<SignInBloc>();
    await sb.setGuestUser();
    if (widget.closeDialog == null || widget.closeDialog == false) {
      nextScreenCloseOthers(context, HomePage());
    } else {
      Navigator.pop(context);
    }
  }

  Future handleGoogleSignIn() async {
    final sb = context.read<SignInBloc>();
    final ib = context.read<InternetBloc>();
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      openSnacbar(_scaffoldKey, 'Check your internet connection!');
    } else {
      await sb.signInWithGoogle().then((_) {
        if (sb.hasError == true) {
          openSnacbar(_scaffoldKey, 'Something is wrong. Please try again.');
          _buttonController.reset();
        } else {
          sb.checkUserExists().then((isUserExisted) async {
            if (isUserExisted) {
              await sb
                  .getUserDataFromFirebase(sb.uid)
                  .then((value) => sb.guestSignout())
                  .then((value) => sb
                      .saveDataToSP()
                      .then((value) => sb.setSignIn().then((value) {
                            _buttonController.success();
                            handleAfterSignupGoogle();
                          })));
            } else {
              sb.getTimestamp().then((value) => sb
                  .saveToFirebase()
                  .then((value) => sb.increaseUserCount())
                  .then((value) => sb.guestSignout())
                  .then((value) => sb
                      .saveDataToSP()
                      .then((value) => sb.setSignIn().then((value) {
                            _buttonController.success();
                            handleAfterSignupGoogle();
                          }))));
            }
          });
        }
      });
    }
  }

  handleAfterSignupGoogle() {
    Future.delayed(Duration(milliseconds: 1000)).then((f) {
      if (widget.closeDialog == null || widget.closeDialog == false) {
        nextScreenCloseOthers(context, HomePage());
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
              child: Image(
                image: AssetImage(Config().splashIcon),
                height: 50,
                width: 50,
                color: Colors.white,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: 20, left: 10, bottom: 10, top: 10),
              child: Text(
                Config().appName,
                style: TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          widget.closeDialog == null || widget.closeDialog == false
              ? TextButton(
                  onPressed: () {
                    handleGuestUser();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      ' Skip',
                      style: GoogleFonts.rubik(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
              
                )
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      ' Skip',
                      style: GoogleFonts.rubik(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      ),
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
              image: AssetImage('assets/images/bridge.jpg'),
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
            Positioned(
                top: h / 1.35,
                child: Container(
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Welcome !",
                        style: GoogleFonts.rubik(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: h / 1.25,
                child: Container(
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "To the land of handpicked retouch wallpapers",
                          style: GoogleFonts.rubik(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
              top: h / 1.12,
              left: w / 60,
              right: w / 60,
              child: Container(
                child: RoundedLoadingButton(

                  successColor: Colors.blueAccent,
                  child: Wrap(
                    children: [
                      Icon(
                        FontAwesomeIcons.google,
                        size: 25,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Sign In with Google',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )
                    ],
                  ),
                  controller: _buttonController,
                  onPressed: () => handleGoogleSignIn(),
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 60,
                  color: Colors.blueAccent,
                  elevation: 0,
                  borderRadius: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
