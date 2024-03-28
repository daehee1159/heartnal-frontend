import 'dart:io';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/models/signal/signal_dto.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/signal/result/recipient_failure_signal.dart';
import 'package:couple_signal/src/screens/signal/result/recipient_success_signal.dart';
import 'package:couple_signal/src/screens/signal/result/sender_failure_signal.dart';
import 'package:couple_signal/src/screens/signal/result/sender_success_signal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _uiResult = false;
const int maxFailedLoadAttempts = 2;
final getIt = GetIt.instance;

class ReceivedSignal extends StatefulWidget {
  final SignalDto signalDto;
  const ReceivedSignal({Key? key, required this.signalDto}) : super(key: key);

  @override
  _ReceivedSignalState createState() => _ReceivedSignalState();
}

class _ReceivedSignalState extends State<ReceivedSignal> {

  static final AdRequest request = AdRequest(
    // keywords: <String>['flutter', 'firebase'],
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
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        // adUnitId: InterstitialAd.testAdUnitId,
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
      print('Warning: attempt to show interstitial before loaded.');
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
            // print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('RewardedAd failed to load: $error');
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
          // print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // print('$BannerAd failedToLoad: $error');
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
                FontAwesomeIcons.envelopeOpenText,
                color: const Color(0xffFE9BE6),
                size: 100,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Center(
                child: Text(
                  '시그널 결과가 도착했어요.',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 23.0),
                ),
              ),
            ),
            Center(
              child: Text(
                '결과를 확인해주세요!',
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
                        '결과 확인하기',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 17.0),
                      ),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: const Color(0xffFE9BE6),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 45)
                      ),
                      onPressed: () async {
                        bool result = await _hasMessage(context, widget.signalDto);

                        if (widget.signalDto.tryCount == "1") {
                          final provider = getIt.get<TempSignal>();
                          provider.setIsWatchingAd = true;
                          /// 광고
                          InterstitialAd.load(
                              // adUnitId: InterstitialAd.testAdUnitId,
                              adUnitId: Glob.interstitialAdUnitId,
                              request: request,
                              adLoadCallback: InterstitialAdLoadCallback(
                                onAdLoaded: (InterstitialAd ad) async {
                                  // print('$ad loaded');
                                  _interstitialAd = ad;
                                  _numInterstitialLoadAttempts = 0;
                                  _interstitialAd!.setImmersiveMode(true);
                                  await _interstitialAd!.show();
                                  if (widget.signalDto.position == 'sender' && widget.signalDto.result == "true") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SenderSuccessSignal()));
                                  } else if (widget.signalDto.position == 'recipient' && widget.signalDto.result == "true") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientSuccessSignal()));
                                  } else if (widget.signalDto.position == 'sender' && widget.signalDto.result == "false") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SenderFailureSignal()));
                                  } else if (widget.signalDto.position == 'recipient' && widget.signalDto.result == "false") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientFailureSignal()));
                                  }
                                },
                                onAdFailedToLoad: (LoadAdError error) {
                                  _numInterstitialLoadAttempts += 1;
                                  _interstitialAd = null;
                                  if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
                                    _createInterstitialAd();
                                  } else if (_numInterstitialLoadAttempts == maxFailedLoadAttempts) {
                                    if (widget.signalDto.position == 'sender' && widget.signalDto.result == "true") {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SenderSuccessSignal()));
                                    } else if (widget.signalDto.position == 'recipient' && widget.signalDto.result == "true") {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientSuccessSignal()));
                                    } else if (widget.signalDto.position == 'sender' && widget.signalDto.result == "false") {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SenderFailureSignal()));
                                    } else if (widget.signalDto.position == 'recipient' && widget.signalDto.result == "false") {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientFailureSignal()));
                                    }
                                  }
                                },
                              )).then((value) => provider.setIsWatchingAd = false);
                        } else {
                          if (widget.signalDto.position == 'sender' && widget.signalDto.result == "true") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SenderSuccessSignal()));
                          } else if (widget.signalDto.position == 'recipient' && widget.signalDto.result == "true") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientSuccessSignal()));
                          } else if (widget.signalDto.position == 'sender' && widget.signalDto.result == "false") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SenderFailureSignal()));
                          } else if (widget.signalDto.position == 'recipient' && widget.signalDto.result == "false") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientFailureSignal()));
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
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 17.0),
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

Future<bool> _hasMessage(BuildContext context, SignalDto signalDto) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool('hasMessage').toString() == "true") {
      pref.setBool('hasMessage', false);
    }

    Signal _signal = Provider.of<Signal>(context, listen: false);
    _signal.setPosition = signalDto.position;
    _signal.setCategory = signalDto.category;
    _signal.setTryCount = int.parse(signalDto.tryCount.toString());

    if (signalDto.eatSignalSeq == null || signalDto.eatSignalSeq == "" || signalDto.eatSignalSeq == "null") {

    } else {
      _signal.setEatSignalSeq = int.parse(signalDto.eatSignalSeq.toString());
    }

    if (signalDto.playSignalSeq == null || signalDto.playSignalSeq == "" || signalDto.playSignalSeq == "null") {
    } else {
      _signal.setPlaySignalSeq = int.parse(signalDto.playSignalSeq.toString());
    }

    _signal.setSenderSelected = signalDto.senderSelected;
    _signal.setRecipientSelected = signalDto.recipientSelected;
    if (signalDto.result != null || signalDto.result != "" || signalDto.result != "null") {
      _signal.setResult = (signalDto.result == "true") ? true : false;
    }

    if (signalDto.result == "true") {
      _uiResult = true;
      _signal.setResultSelected = signalDto.resultSelected;
    } else {
      _uiResult = false;
    }
    return true;
  } catch (e) {
    return false;
  }

}
