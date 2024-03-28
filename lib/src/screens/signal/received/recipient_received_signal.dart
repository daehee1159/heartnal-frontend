import 'dart:io';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/models/signal/signal_dto.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/signal/eat/not_first_recipient_eat_signal.dart';
import 'package:couple_signal/src/screens/signal/eat/first_recipient_eat_signal.dart';
import 'package:couple_signal/src/screens/signal/play/first_recipient_play_signal.dart';
import 'package:couple_signal/src/screens/signal/play/not_first_recipient_play_signal.dart';
import 'package:couple_signal/src/service/global_func.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int maxFailedLoadAttempts = 3;
final getIt = GetIt.instance;

class RecipientReceivedSignal extends StatefulWidget {
  final SignalDto signalDto;
  const RecipientReceivedSignal({Key? key, required this.signalDto}) : super(key: key);

  @override
  _RecipientReceivedSignalState createState() => _RecipientReceivedSignalState();
}

class _RecipientReceivedSignalState extends State<RecipientReceivedSignal> {
  static final AdRequest request = AdRequest(
    keywords: <String>['flutter', 'firebase'],
    // contentUrl: 'https://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  @override
  void initState() {
    super.initState();
    // _createInterstitialAd();
    _createRewardedAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Glob.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: RewardedAd.testAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Glob.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _anchoredBanner?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    bool _isPrimary = (widget.signalDto.senderSelected == '' || widget.signalDto.tryCount == "1") ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/heartnal_bi.png',
          height: MediaQuery.of(context).size.height * 0.04,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: const Icon(
                Icons.favorite,
                color: const Color(0xffFE9BE6),
                size: 100,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Center(
                child: Text(
                  '상대방이 시그널을 보냈어요.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 23.0),
                ),
              ),
            ),
            Center(
              child: Text(
                '시그널에 응답해주세요!',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 23.0),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextButton(
                      child: Text(
                        '시그널 보내기',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: const Color(0xffFE9BE6),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 45)
                      ),
                      onPressed: () async {
                        bool result = await _checkCategory(context, widget.signalDto);

                        if (widget.signalDto.category == 'eatSignal') {
                          if (widget.signalDto.senderSelected == '' || widget.signalDto.tryCount == "1") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientEatPrimaryCategory()));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotFirstRecipientEatSignal()));
                          }
                        } else if (widget.signalDto.category == 'playSignal') {
                          if (widget.signalDto.senderSelected == "" || widget.signalDto.tryCount == "1") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientPlayPrimaryCategory()));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotFirstRecipientPlaySignal()));
                          }
                        }

                        if (!result) {
                          GlobalAlert().globErrorAlert(context);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextButton(
                      child: Text(
                        '메인',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: const Color(0xffFE9BE6),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 45)
                      ),
                      onPressed: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setBool("hasMessage", false);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}

/// 아마 false 를 반환해서 에러가 나는 것 같음
  Future<bool> _checkCategory(BuildContext context, SignalDto signalDto) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('hasMessage').toString() == "true") {
      pref.setBool('hasMessage', false);
    }

    Signal _signal = Provider.of<Signal>(context, listen: false);
    _signal.setPosition = signalDto.position;
    _signal.setCategory = signalDto.category;
    _signal.setTryCount = int.parse(signalDto.tryCount.toString());

    if (signalDto.eatSignalSeq == null || signalDto.eatSignalSeq.toString() == "" || signalDto.eatSignalSeq.toString() == "null") {

    } else {
      _signal.setEatSignalSeq = int.parse(signalDto.eatSignalSeq.toString());
    }
    if (signalDto.playSignalSeq == null || signalDto.playSignalSeq.toString() == "" || signalDto.playSignalSeq.toString() == "null") {

    } else {
      _signal.setPlaySignalSeq = int.parse(signalDto.playSignalSeq.toString());
    }

    _signal.setSenderSelected = signalDto.senderSelected;
    _signal.setRecipientSelected = signalDto.recipientSelected ?? "null";
    _signal.setResultSelected = signalDto.resultSelected ?? "null";
    if (signalDto.result != null || signalDto.result != "" || signalDto.result != "null") {
      _signal.setResult = (signalDto.result == "true") ? true : false;
    }

    return true;
  } catch(e) {
    GlobalFunc().setErrorLog("_checkCategory Error!! params signalDtp = $signalDto");
    return false;
  }
}
