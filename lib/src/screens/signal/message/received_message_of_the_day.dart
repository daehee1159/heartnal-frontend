import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day_dto.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/signal/message/message_of_the_day_page.dart';
import 'package:couple_signal/src/screens/signal/unresolved/message/message_of_the_day_progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../record/message_of_the_day_record.dart';

class ReceivedMessageOfTheDay extends StatelessWidget {
  const ReceivedMessageOfTheDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'images/heartnal_bi.png',
          height: MediaQuery.of(context).size.height * 0.04,
          fit: BoxFit.contain,
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color(0xffFFF1F5).withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      FontAwesomeIcons.heartPulse,
                      size: 60,
                      color: const Color(0xffFE9BE6),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Center(
                    child: Text(
                      "오늘의 한마디가 도착했어요!",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
            Stack(
              alignment: AlignmentDirectional.topCenter,
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Card(
                    // color: const Color(0xffFFF1F5).withOpacity(0.5),
                    child: SingleChildScrollView(
                      child: Container(
                        color: const Color(0xffFFF1F5).withOpacity(0.7),
                        padding: EdgeInsets.fromLTRB(30, 56, 30, 30),
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Center(
                          child: Text(
                            _messageOfTheDay.getMessage.toString(),
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * -0.075,
                  child: Container(
                    child: (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.07,
                      backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                    ) :
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.07,
                      backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                    ),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffFFF1F5).withOpacity(0.7), width: 4),
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            (_messageOfTheDay.getTermination) ?
            Container(
              width: MediaQuery.of(context).size.width * 0.80,
              child: TextButton(
                child: Text(
                  '메인',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xffFE9BE6),
                    minimumSize: Size.fromHeight(50),
                ),
                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.setBool("hasMessage", false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                },
              ),
            ) :
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextButton(
                        child: Text(
                          '메인',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFE9BE6),
                          minimumSize: Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setBool("hasMessage", false);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextButton(
                        child: Text(
                          '답장하기',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFE9BE6),
                          minimumSize: Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setBool("hasMessage", false);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MessageOfTheDayPage()));
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

