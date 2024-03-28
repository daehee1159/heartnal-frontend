import 'dart:convert';

import 'package:couple_signal/src/screens/signup/getting_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BeforeRegistrationErrorPage extends StatelessWidget {
  const BeforeRegistrationErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오류 페이지',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("알 수 없는 오류가 발생했어요.", style: Theme.of(context).textTheme.bodyText2,),
            ),
            Center(
              child: TextButton.icon(
                icon: Icon(FontAwesomeIcons.circleExclamation),
                label: Text(
                  "처음화면으로 돌아가기",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.8)
                ),
                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  var username = pref.getString(Glob.email);
                  var url = Uri.parse(Glob.memberUrl + '/initialization');

                  Map<String, String> headers = {
                    'Content-Type': 'application/json',
                  };

                  var postData;

                  postData = jsonEncode({
                    "username": username.toString(),
                  });

                  http.Response response = await http.post(
                    url,
                    headers: headers,
                    body: postData,
                  );

                  await pref.remove(Glob.email);
                  await pref.remove(Glob.coupleCode);
                  await pref.remove(Glob.nickName);
                  await pref.remove(Glob.coupleRegDt);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => GettingStartedScreen()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
