import 'package:resplash/models/config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsBloc {


  InterstitialAd _interstitialAd;
  RewardedAd _rewardedAd;

  int numOfAttemptLoad = 0;
  int _numRewardedLoadAttempts = 0;

  static initialization(){
    if(MobileAds.instance == null)
    {
      MobileAds.instance.initialize();
    }
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: Config().admobRewardAdId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= 2) {
              createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd(Future<dynamic> onEnd) {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.User dismissed');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
      onAdImpression: (RewardedAd ad){},
    );
    _rewardedAd.setImmersiveMode(true);
    _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
        // ignore: unnecessary_statements
        onEnd;
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }



  // create interstitial ads
  void createInterad(){
    InterstitialAd.load(
      adUnitId: Config().admobInterstitialAdId,
      request: AdRequest(),
      adLoadCallback:InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad){
            _interstitialAd = ad;
            numOfAttemptLoad =0;
          },
          onAdFailedToLoad: (LoadAdError error){
            numOfAttemptLoad += 1;
            _interstitialAd = null;

            if(numOfAttemptLoad<=2){
              createInterad();
            }
          }),
    );

  }


// show interstitial ads to user
  void showInterad(){
    if(_interstitialAd == null){
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(

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
          createInterad();
        }
    );

    _interstitialAd.show();

    _interstitialAd = null;
  }



}