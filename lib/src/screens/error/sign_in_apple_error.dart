import 'package:flutter/material.dart';

class SignInAppleErrorPage extends StatelessWidget {
  const SignInAppleErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '애플 로그인 오류',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "로그인 과정 중 오류가 발생했어요.",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
            Center(
              child: Text(
                "해결 방법",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.blue),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Center(
              child: Text(
                "아이폰 설정 -> Apple ID -> \n암호 및 보안 -> Apple ID를 사용하는 앱 -> \nHeartnal 삭제 -> Heartnal 재실행",
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
