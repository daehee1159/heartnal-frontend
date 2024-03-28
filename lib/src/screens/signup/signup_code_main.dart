import 'package:couple_signal/src/screens/signup/signup_code_create.dart';
import 'package:couple_signal/src/screens/signup/signup_code_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/global/global_variable.dart';

class SignupCodeMain extends StatelessWidget {
  const SignupCodeMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'images/heartnal_bi.png',
                    height: MediaQuery.of(context).size.height * 0.07,
                    // color: const Color(0xffFE9BE6),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Text(
                    '마지막 단계에요',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.0,),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '연인에게 ',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        TextSpan(
                          text: '커플 코드',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6), decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                          text: '를 받았나요?',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ]
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Lottie.asset(
                          'images/json/icon/icon_arrow_down.json',
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Lottie.asset(
                          'images/json/icon/icon_arrow_down.json',
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Yes',
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                            Text(
                              '커플 코드를 받았어요!',
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            TextButton(
                              child: Text(
                                '코드 입력하기',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(15),
                                backgroundColor: const Color(0xffFE9BE6),
                              ),
                              onPressed: () async {
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                String username = pref.getString(Glob.email).toString();
                                String nickName = pref.getString(Glob.nickName).toString();
                                String coupleRegDt = pref.getString(Glob.coupleRegDt).toString();

                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupCodeInput()));
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'No',
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                            Text(
                              '처음 가입이에요!',
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            TextButton(
                              child: Text(
                                '코드 생성하기',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(15),
                                backgroundColor: const Color(0xffFE9BE6),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupCodeCreate()));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
