import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdHelper {
  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await loadInterstitialAd();
  }

  Future<void> loadInterstitialAd() async {
    final AdRequest request = AdRequest();

    InterstitialAd.load(
      adUnitId: "ca-app-pub-4065499643683154/7467215146",
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
    } else {
      print('Interstitial ad was not ready to be shown.');
    }
  }
}
