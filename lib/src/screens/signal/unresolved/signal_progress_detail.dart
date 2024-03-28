import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/models/signal/signal_dto.dart';
import 'package:couple_signal/src/screens/signal/eat/first_recipient_eat_signal.dart';
import 'package:couple_signal/src/screens/signal/eat/not_first_recipient_eat_signal.dart';
import 'package:couple_signal/src/screens/signal/play/first_recipient_play_signal.dart';
import 'package:couple_signal/src/screens/signal/play/not_first_recipient_play_signal.dart';
import 'package:couple_signal/src/screens/signal/received/received_signal.dart';
import 'package:couple_signal/src/screens/signal/received/recipient_received_signal.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignalProgressDetail extends StatefulWidget {
  final bool isMyTurn;
  final String position;
  final String category;
  final int tryCount;
  final int signalSeq;
  final String senderSelected;
  final String recipientSelected;

  const SignalProgressDetail({
    Key? key,
    required this.isMyTurn,
    required this.position,
    required this.category,
    required this.tryCount,
    required this.signalSeq,
    required this.senderSelected,
    required this.recipientSelected
  }) : super(key: key);

  @override
  State<SignalProgressDetail> createState() => _SignalProgressDetailState();
}

class _SignalProgressDetailState extends State<SignalProgressDetail> {
  // Google admob
  final BannerAd myBanner = BannerAd(
    // 테스트 아이디
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    adUnitId: Glob.bannerAdUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  @override
  void initState() {
    super.initState();
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    AdWidget adWidget = AdWidget(ad: myBanner);
    Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "시그널 현황보기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _detailSignalPage(context),
            SizedBox(height: 10.0,),
            (widget.isMyTurn == true) ?
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Card(
                elevation: 4.0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (this.widget.position == "sender") ?
                      Text(
                        "시그널에 대한 답변이 도착했어요.",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                      ) :
                      Text(
                        "상대방이 시그널을 보냈어요.",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                      ),
                      SizedBox(height: 10.0,),
                      (this.widget.position == "sender") ?
                      Text(
                        "시그널 결과를 확인해주세요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ) :
                      Text(
                        "시그널 답변을 보내주세요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
                      (this.widget.position == "sender") ?
                      TextButton(
                        child: Text(
                          "결과 보기",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFE9BE6),
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.013, horizontal: MediaQuery.of(context).size.width * 0.12)
                        ),
                        onPressed: () {
                          String eatSignalSeq = (this.widget.category == "eatSignal") ? this.widget.signalSeq.toString() : "";
                          String playSignalSeq = (this.widget.category == "playSignal") ? this.widget.signalSeq.toString() : "";
                          String termination = "true";
                          String result = (this.widget.senderSelected == this.widget.recipientSelected) ? "true" : "false";
                          String resultSelected = (this.widget.senderSelected == this.widget.recipientSelected) ? this.widget.senderSelected : "";

                          SignalDto signalDto = SignalDto(
                              "", "", "", "", "", "true",
                              this.widget.position, this.widget.category, this.widget.tryCount.toString(),
                              eatSignalSeq, playSignalSeq, "","", "",
                              this.widget.senderSelected, this.widget.recipientSelected,
                              termination, result, resultSelected
                          );

                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedSignal(signalDto: signalDto,)));
                        },
                      ) :
                      TextButton(
                        child: Text(
                          "시그널 보내기",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFE9BE6),
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: MediaQuery.of(context).size.height * 0.005)
                        ),
                        onPressed: () async {
                          String eatSignalSeq = (this.widget.category == "eatSignal") ? this.widget.signalSeq.toString() : "";
                          String playSignalSeq = (this.widget.category == "playSignal") ? this.widget.signalSeq.toString() : "";
                          String termination = "false";

                          // SignalDto signalDto = SignalDto(
                          //     "", "", "", "", "", "true",
                          //     this.widget.position, this.widget.category, this.widget.tryCount.toString(),
                          //     eatSignalSeq, playSignalSeq,
                          //     this.widget.senderSelected, "",
                          //     termination, "", ""
                          // );

                          bool result = await _checkCategory(context);

                          if (this.widget.category == "eatSignal") {
                            if (this.widget.tryCount == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientEatPrimaryCategory()));
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NotFirstRecipientEatSignal()));
                            }
                          } else {
                            if (this.widget.tryCount == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientPlayPrimaryCategory()));
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NotFirstRecipientPlaySignal()));
                            }
                          }
                          if (!result) {
                            GlobalAlert().globErrorAlert(context);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ) :
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Card(
                elevation: 4.0,
                child: Container(
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage("images/background_img.jpg"),
                  //         fit: BoxFit.cover
                  //     )
                  // ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// 여기서 position 은 CheckMyTurn 의 myPosition 을 의미
                      Text(
                        "시그널 진행중!",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        "상대방의 시그널을 기다리고 있어요.",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        "시그널 답변을 기다려주세요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ),
                      /// 투두 시그널 조르기 기능
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: adContainer,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailSignalPage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Card(
        elevation: 4.0,
        child: Container(
          // color: const Color(0xffFFF1F5),
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("images/background_img.jpg"),
          //         fit: BoxFit.cover
          //     )
          // ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                this.widget.category == "eatSignal" ? "오늘 뭐먹지?" : "오늘 뭐하지",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width * 0.20,
                                        color: const Color(0xffFE9BE6),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 0,
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 25,
                                      color: const Color(0xffFE9BE6),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.065,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child:Text(
                              '첫번째 시도',
                              style: (this.widget.tryCount == 1) ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      (this.widget.tryCount == 2 || this.widget.tryCount == 3) ?
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width * 0.20,
                                        color: const Color(0xffFE9BE6),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 0,
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 25,
                                      color: const Color(0xffFE9BE6),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.065,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child:Text(
                              '두번째 시도',
                              style: (this.widget.tryCount == 2) ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ) :
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width * 0.20,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 0,
                                    child: Icon(
                                      Icons.circle,
                                      size: 25,
                                      color: Colors.grey.withOpacity(0.7),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.065,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child:Text(
                              '두번째 시도',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      (this.widget.tryCount == 3) ?
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        // width: double.infinity,
                                        width: MediaQuery.of(context).size.width * 0.20,
                                        color: const Color(0xffFE9BE6),
                                        // margin: const EdgeInsets.only(left: 0.0,top: 5,right: 0.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 0,
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 25,
                                      color: const Color(0xffFE9BE6),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.065,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child:Text('세번째 시도'),
                          ),
                        ],
                      ) :
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width * 0.20,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 0,
                                    child: Icon(
                                      Icons.circle,
                                      size: 25,
                                      color: Colors.grey.withOpacity(0.7),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.065,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child:Text(
                              '세번째 시도',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _checkCategory(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.getBool('hasMessage').toString() == "true") {
        pref.setBool('hasMessage', false);
      }

      Signal _signal = Provider.of<Signal>(context, listen: false);
      _signal.setPosition = this.widget.position;
      _signal.setCategory = this.widget.category;
      _signal.setTryCount = int.parse(this.widget.tryCount.toString());

      if (this.widget.category == "eatSignal") {
        _signal.setEatSignalSeq = this.widget.signalSeq;
      } else {
        _signal.setPlaySignalSeq = this.widget.signalSeq;
      }

      _signal.setSenderSelected = this.widget.senderSelected;
      _signal.setRecipientSelected = this.widget.recipientSelected;
      return true;
    } catch(e) {
      return false;
    }
  }
}
