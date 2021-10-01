import 'package:flutter/foundation.dart';
import 'package:resplash/models/config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class AdsBloc {

  InterstitialAd interstitialAd;
  static const int maxFailedLoadAttempts = 3;
  int _interstitialLoadAttempts = 0;

  static initialization(){
    if(MobileAds.instance == null)
    {
      MobileAds.instance.initialize();
    }
  }

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

  }

  // void showInterstitialAd() {
  //   if (interstitialAd != null) {
  //     interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //         ad.dispose();
  //         createInterstitialAd();
  //         notifyListeners();
  //       },
  //       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //         ad.dispose();
  //         createInterstitialAd();
  //         notifyListeners();
  //       },
  //     );
  //     interstitialAd.show();
  //     notifyListeners();
  //   }
  // }

  void showInterstitialAd(){
    if(interstitialAd == null){
      return;
    }
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad){
          print("ad onAdshowedFullscreen");
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad){
          print("ad Disposed");
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror){
          print('$ad OnAdFailed $aderror');
          ad.dispose();
          createInterstitialAd();
        }
    );
    interstitialAd.show();
    interstitialAd = null;
  }


}
