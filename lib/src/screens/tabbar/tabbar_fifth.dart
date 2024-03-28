import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/screens/settings/app_version.dart';
import 'package:couple_signal/src/screens/settings/create_couple.dart';
import 'package:couple_signal/src/screens/settings/create_couple_code.dart';
import 'package:couple_signal/src/screens/settings/delete_account.dart';
import 'package:couple_signal/src/screens/settings/disconnect_couple.dart';
import 'package:couple_signal/src/screens/settings/edit_profile.dart';
import 'package:couple_signal/src/screens/settings/faq.dart';
import 'package:couple_signal/src/screens/settings/one_on_one_inquiry.dart';
import 'package:couple_signal/src/screens/settings/privacy.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class TabBarFifth extends StatefulWidget {
  const TabBarFifth({Key? key}) : super(key: key);

  @override
  _TabBarFifthState createState() => _TabBarFifthState();
}

class _TabBarFifthState extends State<TabBarFifth> {
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
      body: ListView(
        children: [
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                  child: Text(
                    '내정보',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black, fontSize: 17.0),),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "내 프로필 수정",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.language, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "커플 코드 생성",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCoupleCode()));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.favorite, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "커플 연동",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCouple()));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(FontAwesomeIcons.heartBroken, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "커플 해제",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DisconnectCouple()));
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 4.0,
            margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(FontAwesomeIcons.bullhorn, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "공지사항",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () async {
                    /// 하트널 인스타그램으로 연결
                    if (await canLaunch('https://www.instagram.com/heartnal/')) {
                      launch('https://www.instagram.com/heartnal/');
                    }
                    // final Uri _url = Uri.parse('https://www.instagram.com/heartnal/');
                    // if (!await launchUrl(_url)) {
                    //   throw 'Could not launch $_url';
                    // }
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.question_mark, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "FAQ",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FAQ()));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.headphones, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "1:1 문의하기",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OneOnOneInquiry()));
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 4.0,
            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                  child: Text(
                    '접근 및 권한',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black, fontSize: 17.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "위치 설정",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () async {
                    Location location = new Location();

                    bool _serviceEnabled;
                    PermissionStatus _permissionGranted;
                    LocationData _locationData;

                    _serviceEnabled = await location.serviceEnabled();
                    if (!_serviceEnabled) {
                      _serviceEnabled = await location.requestService();
                      if (!_serviceEnabled) {
                        return;
                      }
                    }
                    _permissionGranted = await location.hasPermission();
                    if (_permissionGranted == PermissionStatus.denied) {
                      _permissionGranted = await location.requestPermission();
                      if (_permissionGranted != PermissionStatus.granted) {
                        return;
                      }
                    }

                    if (_serviceEnabled && _permissionGranted != PermissionStatus.denied) {
                      return _alertDialog(context);
                    }
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 4.0,
            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                  child: Text(
                    '애플리케이션 정보',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black, fontSize: 17.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "버전 정보",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AppVersion()));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Icon(Icons.lock, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "약관 및 개인정보 처리방침",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPage()));
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 4.0,
            margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.remove_circle, color: Theme.of(context).iconTheme.color,),
                  title: Text(
                    "탈퇴하기",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: const Color(0xff5D5D5D),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccount()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0,),
          /// 광고
          adContainer
        ],
      )
    );
  }

  Container _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  _alertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "위치 설정 허용",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleCheck,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '설정이 허용되었어요!',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }
}
