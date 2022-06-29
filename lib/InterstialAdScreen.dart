
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class InterstialAdScreen extends StatefulWidget {
  @override
  _InterstialAdScreenState createState() => _InterstialAdScreenState();
}

class _InterstialAdScreenState extends State<InterstialAdScreen> {
  InterstitialAd myInterstitial;
  @override
  void initState() {
    super.initState();
   // initalizeInterstial();
   // myInterstitial.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Stack(
        children: [],
      )),
    );
  }


 // void initalizeInterstial() {
  //  final AdListener listener = AdListener(
      // Called when an ad is successfully received.
 //     onAdLoaded: (Ad ad) {
   //     print("adloaded=> Ad loaded.");
     //   myInterstitial.show();
   //   },
      // Called when an ad request failed.
    //  onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //    ad.dispose();
    //    print('adloaded=> Ad failed to load: $error');
    //  },
      // Called when an ad opens an overlay that covers the screen.
    //  onAdOpened: (Ad ad) => print('adloaded=> Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
    //  onAdClosed: (Ad ad) {
     //   ad.dispose();
     //   print('adloaded=> Ad closed.');
   //   },
      // Called when an ad is in the process of leaving the application.
   //   onApplicationExit: (Ad ad) => print('Left application.'),
 //   );

  //  myInterstitial = InterstitialAd(
   //   adUnitId: 'ca-app-pub-3940256099942544/8691691433',
  //    request: AdRequest(),
  //    listener: listener,
  //  );
  //}
}
