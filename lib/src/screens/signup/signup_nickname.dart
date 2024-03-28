import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/screens/signup/signup_couple_regdt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupNickName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = new TextEditingController();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'images/heartnal_bi.png',
                      height: MediaQuery.of(context).size.height * 0.07,
                      // color: const Color(0xffFE9BE6),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    Text(
                      '닉네임을 설정해주세요.',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
                    TextField(
                      controller: nameController,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18.0),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: '닉네임을 입력해주세요.',
                        hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0, color: Colors.grey),
                        contentPadding: const EdgeInsets.all(15),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    TextButton(
                      child: Text(
                        '다음',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(15),
                        backgroundColor: const Color(0xffFE9BE6),
                      ),
                      onPressed: () {
                        /// 닉네임을 입력하지 않은 경우 alert
                        if (nameController.value.text == '' || nameController.value.text == ' ' || nameController.value.text == '  ' || nameController.value.text == 'null') {
                          _alertDialog(context);
                        } else {
                          _setNickName(nameController.value.text);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupCoupleRegDt()));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  // 닉네임 저장
  void _setNickName(String nickName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Glob.nickName, nickName);
  }

  _alertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "닉네임 미입력",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '닉네임을 입력해주세요!',
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
