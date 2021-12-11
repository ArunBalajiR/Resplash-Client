import 'package:resplash/models/config.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsBloc extends ChangeNotifier {


  static initialize(){
    if(MobileAds.instance == null){
      MobileAds.instance.initialize();
    }
  }

  @override
  void dispose() {
    disposeAdmobInterstitialAd();
    disposeAdmobRewardAd();
    super.dispose();
  }

  bool _admobAdLoaded = false;
  bool get admobAdLoaded => _admobAdLoaded;
  InterstitialAd? _interstitialAd;

  bool _admobRewardAdLoaded = false;
  bool get admobRewardAdLoaded => _admobRewardAdLoaded;
  RewardedAd? _rewardedAd;



  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: Config().admobRewardAdId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _admobRewardAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _admobRewardAdLoaded = false;
            notifyListeners();
            loadAdmobARewardad();
          },
        ));
  }

   void showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.User dismissed');
        ad.dispose();
        _rewardedAd = null;
        _admobRewardAdLoaded = false;
        notifyListeners();
        loadAdmobARewardad();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _rewardedAd = null;
        _admobRewardAdLoaded = false;
        notifyListeners();
        loadAdmobARewardad();
      },
      onAdImpression: (RewardedAd ad){},
    );
    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
        // ignore: unnecessary_statements
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
    notifyListeners();
  }



  // create interstitial ads
  void createInterad(){
    InterstitialAd.load(
      adUnitId: Config().admobInterstitialAdId,
      request: AdRequest(),
      adLoadCallback:InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad){
            print("$ad loaded");
            _interstitialAd = ad;
            _admobAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error){
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            _admobAdLoaded = false;
            notifyListeners();
            loadAdmobInterstitialAd();

          }),
    );

  }



// show interstitial ads to user
  void showInterstitialAdAdmob() {
    if(_interstitialAd != null){

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          _interstitialAd = null;
          _admobAdLoaded = false;
          notifyListeners();
          loadAdmobInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          _interstitialAd = null;
          _admobAdLoaded = false;
          notifyListeners();
          loadAdmobInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      notifyListeners();
    }
  }

  Future loadAdmobInterstitialAd() async {
    if(_admobAdLoaded == false){
      createInterad();
    }
  }

  Future disposeAdmobInterstitialAd() async {
    _interstitialAd?.dispose();
    notifyListeners();
  }

  Future loadAdmobARewardad() async {
    if(_admobRewardAdLoaded == false){
      createRewardedAd();
    }
  }

  Future disposeAdmobRewardAd() async {
    _rewardedAd?.dispose();
    notifyListeners();
  }




}