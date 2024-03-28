import 'dart:ui';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/screens/settings/edit_profile.dart';
import 'package:couple_signal/src/screens/splash_screen.dart';
import 'package:couple_signal/src/service/global_func.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:couple_signal/src/service/storage_service.dart';

import '../home.dart';

class TabBarFirst extends StatefulWidget {
  const TabBarFirst({Key? key}) : super(key: key);

  @override
  _TabBarFirstState createState() => _TabBarFirstState();
}

class _TabBarFirstState extends State<TabBarFirst> {
  bool isSized2000 = window.physicalSize.height > 2000;
  GlobalAlert globalAlert = new GlobalAlert();
  final Storage storage = Storage();

  FocusNode focusNode = FocusNode();

  TextEditingController _nickNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
    focusNode = FocusNode();
    _nickNameController = new TextEditingController();
    myBanner.load();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);

    /// 커플 연동 해제 및 다시 커플 연동하는 경우 DB의 커플 코드와 pref의 커플 코드가 다를 수 있음 그래서 실행함
    GlobalFunc().checkCoupleCode(context);

    AdWidget adWidget = AdWidget(ad: myBanner);
    Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xffEEEEEE),
      body: Container(
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        imageProfile((_myProfileInfo.myProfileImgAddr.toString() == 'null') ? 'null' : _myProfileInfo.myProfileImgAddr.toString(), 'myProfileImgAddr', context),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: OverflowBox(
                                minHeight: MediaQuery.of(context).size.height * 0.08,
                                maxHeight: MediaQuery.of(context).size.height * 0.08,
                                minWidth: MediaQuery.of(context).size.width * 0.12,
                                maxWidth: MediaQuery.of(context).size.width * 0.12,
                                child: Lottie.asset(
                                  'images/json/icon/icon_heart.json',
                                  width: MediaQuery.of(context).size.width * 0.12,
                                  height: MediaQuery.of(context).size.height * 0.08
                                ),
                              ),
                            ),
                            Text(
                              _myProfileInfo.coupleRegDt == 'null' ? '0' : _myProfileInfo.dDay.toString(),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        imageProfile((_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ? 'null' :_myProfileInfo.coupleProfileImgAddr.toString().replaceAll('localhost', '10.0.2.2'), 'coupleProfileImgAddr', context)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: isSized2000 ? 3 : 4,
                            child: Center(
                              child: GestureDetector(
                                child: Text((_myProfileInfo.nickName.toString() == '' || _myProfileInfo.nickName.toString() == 'null') ? '미등록' : _myProfileInfo.getNickName),
                                onTap: () async {
                                  _nickNameController = TextEditingController(text: _myProfileInfo.getNickName);
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                              return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Icon(
                                                        FontAwesomeIcons.edit,
                                                        color: const Color(0xffFE9BE6),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Padding(
                                                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.005, 0, 0),
                                                        child: Text(
                                                          '닉네임 변경',
                                                          style: Theme.of(context).textTheme.bodyText1,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                content: TextField(
                                                  // focusNode: focusNode,
                                                  decoration: InputDecoration(
                                                    // border: InputBorder.none,
                                                  ),
                                                  controller: _nickNameController,
                                                  key: _formKey,
                                                  style: Theme.of(context).textTheme.bodyText2,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      '저장',
                                                      style: Theme.of(context).textTheme.bodyText2,
                                                    ),
                                                    onPressed: () {
                                                      _myProfileInfo.updateNickName(_nickNameController.text.toString());
                                                      _myProfileInfo.setNickName = _nickNameController.text.toString();
                                                      Navigator.pop(context);
                                                      _setState();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      '취소',
                                                      style: Theme.of(context).textTheme.bodyText2,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            }
                                        );
                                      }
                                  );
                                  // focusNode.requestFocus();
                                },
                              ),
                            )
                        ),
                        Expanded(
                          flex: isSized2000 ? 1 : 2,
                          child: const Text(''),
                        ),
                        Expanded(
                            flex: isSized2000 ? 3 : 4,
                            child: Center(
                                child: Text((_myProfileInfo.coupleNickName.toString() == '' || _myProfileInfo.coupleNickName.toString() == 'null') ? '미등록' : _myProfileInfo.coupleNickName.toString())
                            )
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB((isSized2000 ? (_myProfileInfo.myExpressionText!.length > 4) ? MediaQuery.of(context).size.width * 0.03 : MediaQuery.of(context).size.width * 0.05  : 0), 0, 0, 0),
                                    child: _myProfileInfo.getMyExpressionWidget
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(
                                    _myProfileInfo.getMyExpressionText,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              checkExpressionAlert(context);
                            },
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: SizedBox()
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: _myProfileInfo.coupleExpressionWidget,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  _myProfileInfo.coupleExpressionText.toString(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            mainBannerImage(_myProfileInfo.mainBannerImgAddr.toString(), context),
            const SizedBox(height: 10.0,),
            /// 광고
            adContainer
          ],
        ),
      ),
    );
  }

  Widget mainBannerImage(String imgAddr, BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    if (imgAddr == "null" || imgAddr == "") {
      return Card(
        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Container(
            height: isSized2000 ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/daily_date.png")
                )
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 3, 0),
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet("mainBannerImgAddr", context)));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            )
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Container(
            height: isSized2000 ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_myProfileInfo.getMainBannerImgUrl)
                )
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 3, 0),
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet("mainBannerImgAddr", context)));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            )
        ),
      );
    }
  }

  Widget imageProfile(String imgAddr, String imgOf, BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    if ((imgAddr == "null" || imgAddr == "") && isSized2000) {
      return Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.18,
              backgroundImage: const AssetImage('images/basic_profile_img.jpg'),
            ),
            (imgOf == 'coupleProfileImgAddr') ?
            Padding(
              padding: EdgeInsets.all(0),
            ) :
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet(imgOf, context)));
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: const Color(0xffFE9BE6),
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      );
    } else if ((imgAddr == "null" || imgAddr == "") && !isSized2000) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.13,
                backgroundImage: const AssetImage('images/basic_profile_img.jpg'),
              ),
              (imgOf == 'coupleProfileImgAddr') ?
              Padding(
                padding: EdgeInsets.all(0),
              ) :
              Positioned(
                bottom: 20,
                right: 20,
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet(imgOf, context)));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: const Color(0xffFE9BE6),
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      if (isSized2000) {
        return Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.18,
                backgroundImage: NetworkImage(
                    (imgOf == 'myProfileImgAddr') ? _myProfileInfo.getMyProfileImgUrl : _myProfileInfo.getCoupleProfileImgUrl
                ),
              ),
              (imgOf == 'coupleProfileImgAddr') ?
              Padding(
                padding: EdgeInsets.all(0),
              ) :
              Positioned(
                bottom: 20,
                right: 20,
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet(imgOf, context)));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (!isSized2000) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.13,
                  backgroundImage: NetworkImage(
                      (imgOf == 'myProfileImgAddr') ? _myProfileInfo.getMyProfileImgUrl : _myProfileInfo.getCoupleProfileImgUrl
                  ),
                ),
                (imgOf == 'coupleProfileImgAddr') ?
                Padding(
                  padding: EdgeInsets.all(0),
                ) :
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet(imgOf, context)));
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    }
  }

  Widget iOSBottomSheet(String imgOf, BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    final provider = getIt.get<TempSignal>();
    String uploadPath = imgOf == "mainBannerImgAddr" ? "main_banner" : "profile";
    return CupertinoActionSheet(
      actions: [
        Container(
          color: Colors.white,
          child: CupertinoActionSheetAction(
            child: Text(
              imgOf == "mainBannerImgAddr" ? "메인 배너 이미지 선택" : "프로필 이미지 선택",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13),
            ),
            onPressed: () {},
          ),
        ),
        Container(
          color: Colors.white,
          child: CupertinoActionSheetAction(
            child: Text(
              "앨범에서 선택",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),
            ),
            onPressed: () async {
              /// Navigator.pop(context)으로 기존 선택창을 닫고 앨범으로 이동
              Navigator.pop(context);

              final results = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.media,
                // allowedExtensions: ['png', 'jpg'],
              );
              if (results == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '선택된 파일이 없어요.',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  )
                );
                return null;
              }
              final path = results.files.single.path!;
              final fileName = results.files.single.name;

              bool result = await storage.uploadFile(path, fileName, uploadPath);

              List<String> deleteFile = [];

              if (result && imgOf == "mainBannerImgAddr" && (_myProfileInfo.mainBannerImgAddr.toString() != "null" || _myProfileInfo.mainBannerImgAddr.toString() != "")) {
                /// 업데이트 해주기 전에 그 전 사진은 삭제해야함
                /// 단, 프로필과 배경이미지가 같은 사진이라면 지우면 안됨
                if (_myProfileInfo.mainBannerImgAddr.toString() == _myProfileInfo.myProfileImgAddr.toString()) {
                  await _myProfileInfo.updateMainBannerImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                } else {
                  deleteFile.add(_myProfileInfo.mainBannerImgAddr.toString());
                  await storage.deleteFile(deleteFile, "main_banner");
                  await _myProfileInfo.updateMainBannerImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                }
              } else if (result && imgOf == "mainBannerImgAddr" && _myProfileInfo.mainBannerImgAddr.toString() == "null" || _myProfileInfo.mainBannerImgAddr.toString() == "") {
                await _myProfileInfo.updateMainBannerImgAddr(fileName);
                // _setState();
                provider.setIsIntentional = true;
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
              } else if (result && imgOf == "myProfileImgAddr" && (_myProfileInfo.myProfileImgAddr.toString() != "null" || _myProfileInfo.myProfileImgAddr.toString() != "")) {
                if (_myProfileInfo.mainBannerImgAddr.toString() == _myProfileInfo.myProfileImgAddr.toString()) {
                  await _myProfileInfo.updateProfileImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                } else {
                  deleteFile.add(_myProfileInfo.myProfileImgAddr.toString());
                  await storage.deleteFile(deleteFile, "profile");
                  await _myProfileInfo.updateProfileImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                }
              } else if (result && imgOf == "myProfileImgAddr" && (_myProfileInfo.myProfileImgAddr.toString() == "null" || _myProfileInfo.myProfileImgAddr.toString() == "")) {
                await _myProfileInfo.updateProfileImgAddr(fileName);
                // _setState();
                provider.setIsIntentional = true;
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
              } else {
                globalAlert.globErrorAlert(context);
              }
            },
            isDefaultAction: true,
          ),
        ),
        Container(
          color: Colors.white,
          child: CupertinoActionSheetAction(
            child: Text(
              "기본 이미지 선택",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),
            ),
            onPressed: () async {
              /// 기본 이미지 선택하면 null 로 바꿔줘야함
              List<String> deleteFile = [];

              if (imgOf == "mainBannerImgAddr") {
                if (_myProfileInfo.mainBannerImgAddr.toString() != _myProfileInfo.myProfileImgAddr.toString()) {
                  deleteFile.add(_myProfileInfo.mainBannerImgAddr.toString());
                  await storage.deleteFile(deleteFile, "main_banner");
                  _myProfileInfo.updateMainBannerImgAddr("null");
                }
              } else {
                if (_myProfileInfo.mainBannerImgAddr.toString() != _myProfileInfo.myProfileImgAddr.toString()) {
                  deleteFile.add(_myProfileInfo.myProfileImgAddr.toString());
                  await storage.deleteFile(deleteFile, "profile");
                  _myProfileInfo.updateProfileImgAddr("null");
                }
              }
              setState(() {
                provider.setIsIntentional = true;
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
              });
            },
            isDefaultAction: true,
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "Cancel",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  checkExpressionAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "감정 표현 변경",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '감정표현 변경하러 가기',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
          },
        ),
        TextButton(
          child: Text(
            '취소',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
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
  _setState() {
    setState(() {});
  }
}
