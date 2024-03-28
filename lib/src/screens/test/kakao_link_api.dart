import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

import '../../models/info/my_profile_info.dart';
import '../../models/kakao/kakao_share_manager.dart';

class KakaoLinkApi extends StatefulWidget {
  const KakaoLinkApi({Key? key}) : super(key: key);

  @override
  State<KakaoLinkApi> createState() => _KakaoLinkApiState();
}

class _KakaoLinkApiState extends State<KakaoLinkApi> {

  @override
  void initState() {
    KakaoSdk.init(nativeAppKey: Platform.environment['KAKAO_NATIVE_APP_KEY'], javaScriptAppKey: Platform.environment['KAKAO_JAVASCRIPT_APP_KEY']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    String nickName = _myProfileInfo.nickName.toString();
    String coupleNickName = _myProfileInfo.coupleNickName.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '카카오 링크 테스트'
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: TextButton(
                child: Text('공유하기 테스트'),
                onPressed: () {
                  KakaoShareManager().isKakaotalkInstalled().then((installed) {
                    if (installed) {
                      KakaoShareManager().shareMyCode(nickName, coupleNickName, 70);
                    } else {
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
