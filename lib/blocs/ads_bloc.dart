// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:resplash/models/config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class AdsBloc extends ChangeNotifier {



  @override
  void dispose() {
    disposeInterstitialAd();      //admob
    //destroyFbAd();                       //fb
    super.dispose();
  }


  //admob Ads -------Start--------
  InterstitialAd interstitialAd;
  static const int maxFailedLoadAttempts = 3;
  int _interstitialLoadAttempts = 0;

/*
  InterstitialAd createAdmobInterstitialAd() {
    return InterstitialAd(
      adUnitId: Config().admobInterstitialAdId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
        if (event == MobileAdEvent.closed) {
          loadAdmobInterstitialAd();
        } else if (event == MobileAdEvent.failedToLoad) {
          disposeAdmobInterstitialAd().then((_) {
            loadAdmobInterstitialAd();
          });
        }
        notifyListeners();
      },
    );
  }
*/
  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Config().admobAppId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },

      ),

    );
    notifyListeners();
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
          notifyListeners();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstitialAd();
          notifyListeners();
        },
      );
      interstitialAd.show();
      notifyListeners();
    }
  }
  //
  // Future loadAdmobInterstitialAd() async {
  //   await _admobInterstitialAd?.dispose();
  //   _admobInterstitialAd = createAdmobInterstitialAd()..load();
  //   notifyListeners();
  // }

  Future disposeInterstitialAd() async {
    interstitialAd.dispose();
    notifyListeners();
  }

  // showAdmobInterstitialAd() {
  //   _admobInterstitialAd?.show();
  //   notifyListeners();
  // }

  // admob ads --------- end --------






  //fb ads ----------- start ----------

  // bool _fbadloaded = false;
  // bool get fbadloaded => _fbadloaded;


  // Future loadFbAd() async{
  //   FacebookInterstitialAd.loadInterstitialAd(
  //     placementId: Config().facebookInterstitialAdId,
  //     listener: (result, value) {
  //       print(result);
  //       if (result == InterstitialAdResult.LOADED){
  //         _fbadloaded = true;
  //         print('ads loaded');
  //         notifyListeners();
  //       }else if(result == InterstitialAdResult.DISMISSED && value["invalidated"] == true){
  //         _fbadloaded = false;
  //         print('ads dismissed');
  //         loadFbAd();
  //         notifyListeners();
  //       }

  //     }
  //   );
  // }



  // Future showFbAdd() async{
  //   if(_fbadloaded == true){
  //   await FacebookInterstitialAd.showInterstitialAd();
  //   _fbadloaded = false;
  //   notifyListeners();
  //   }

  // }



  // Future destroyFbAd() async{
  //   if (_fbadloaded == true) {
  //     FacebookInterstitialAd.destroyInterstitialAd();
  //     _fbadloaded = false;
  //     notifyListeners();
  //   }
  // }




  //fb ads ----------- end ----------


}
