import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:resplash/blocs/ads_bloc.dart';
import 'package:resplash/models/dark_theme_provider.dart';
import 'package:resplash/models/theme_data.dart';
import 'package:resplash/pages/signin_page.dart';
import './blocs/bookmark_bloc.dart';
import './blocs/data_bloc.dart';
import './blocs/internet_bloc.dart';
import './blocs/sign_in_bloc.dart';
import './blocs/userdata_bloc.dart';
import './pages/home.dart';

List<String> testDeviceIds = ['D4D86FDE7CB34417834875CD469C2567'];


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //----
  RequestConfiguration configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  MobileAds.instance.initialize();
  //---
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {


    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => themeChangeProvider,
        ),
        ChangeNotifierProvider<DataBloc>(
          create: (context) => DataBloc(),
        ),
        ChangeNotifierProvider<SignInBloc>(
          create: (context) => SignInBloc(),
        ),
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        ChangeNotifierProvider<AdsBloc>(
          create: (context) => AdsBloc(),
        ),
      ],
      child: Consumer<DarkThemeProvider>(builder: (context, themeData, child) {

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:Styles.themeData(themeChangeProvider.darkTheme, context),
          home: MyApp1(),
        );
      }),
    );
  }
}

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return sb.isSignedIn == false && sb.guestUser == false
        ? SignInPage()
        : HomePage();
  }
}
// java -jar bundletool.jar build-apks --bundle=build\app\outputs\bundle\release\app-release.aab --output=reflix_app.apks --mode=universal