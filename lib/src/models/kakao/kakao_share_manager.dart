import 'dart:io';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_share.dart';
import 'package:couple_signal/src/service/storage_service.dart';

class KakaoShareManager {
  static final KakaoShareManager _manager = KakaoShareManager._internal();

  factory KakaoShareManager() {
    return _manager;
  }

  KakaoShareManager._internal() {
    // ??
  }

  void initializeKakaoSDK() {
    // String kakaoAppKey = '63728264cf0b8acd5edc82acce8f83e1';
    // KakaoContext.clientId = kakaoAppKey;
    KakaoSdk.init(nativeAppKey: '63728264cf0b8acd5edc82acce8f83e1', javaScriptAppKey: '72d7ea1b93e432072ef19b729b2b8de2');
  }

  Future<bool> isKakaotalkInstalled() async {
    bool installed = await isKakaoTalkInstalled();
    return installed;
  }

  void shareMyCode(String nickName, String coupleNickName, int finalScore) async {
    try {
      final Storage storage = Storage();
      String imgAddress = await storage.downloadURL('kakao_link_img.jpg', "basic");

      // 닉네임 줘야함
      var template = _getTemplate(imgAddress, nickName, coupleNickName, finalScore);
      var uri = await ShareClient.instance.shareDefault(template: template);
      await ShareClient.instance.launchKakaoTalk(uri);
    } catch (error) {
      print(error.toString());
    }
  }

  /// 이 템플릿을 기준으로 메시지 전달 (테스트 성공함)

  DefaultTemplate _getTemplate(String imgAddress, String nickName, String coupleNickName, int finalScore) {
    String title = '$nickName ♥ $coupleNickName 커플의 오늘의 시그널은 $finalScore점 이에요!\n하트널에서 문제를 풀고 오늘의 시그널 점수를 확인해보세요!';
    Uri imageLink = Uri.parse(imgAddress);
    Link link = Link(
      webUrl: Uri.parse(Platform.isIOS ? "https://apps.apple.com/kr/app/%ED%95%98%ED%8A%B8%EB%84%90heartnal/1615266807" : "https://play.google.com/store/apps/details?id=com.msm.couple_signal"),
      mobileWebUrl: Uri.parse(Platform.isIOS ? "https://apps.apple.com/kr/app/%ED%95%98%ED%8A%B8%EB%84%90heartnal/1615266807" : "https://play.google.com/store/apps/details?id=com.msm.couple_signal")
    );

    Content content = Content(
      title: title,
      imageUrl: imageLink,
      link: link
    );

    FeedTemplate template = FeedTemplate(
      content: content,
      // social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
      buttons: [
        Platform.isIOS ?
        Button(title: '하트널 다운로드', link: Link(webUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.msm.couple_signal"))) :
        Button(title: '하트널 다운로드', link: Link(webUrl: Uri.parse("apps.apple.com/kr/app/%ED%95%98%ED%8A%B8%EB%84%90heartnal/1615266807")))
      ]
    );

    return template;
  }
}
