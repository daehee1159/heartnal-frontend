import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/screens/signal/eat/not_first_sender_eat_signal.dart';
import 'package:couple_signal/src/screens/signal/play/not_first_sender_play_signal.dart';
import 'package:flutter/material.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

/// Sender 실패 페이지
class SenderFailureSignal extends StatelessWidget {
  const SenderFailureSignal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Signal _signal = Provider.of<Signal>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '시그널 매칭 실패',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 23.0),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
            Center(
              child: const Icon(
                FontAwesomeIcons.heartBroken,
                color: const Color(0xffFE9BE6),
                size: 100,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            (_signal.getTryCount == 3) ?
                Column(
                  children: [
                    Center(
                      child: Text(
                        '3번의 기회를 모두 소진했어요!',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    TextButton(
                      child: Text(
                        "메인",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFE9BE6),
                          minimumSize: Size.fromHeight(50)
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                      },
                    )
                  ],
                )
            :
                TextButton(
                  child: Text(
                    '다시 시도하기',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffFE9BE6),
                      minimumSize: Size.fromHeight(50)
                  ),
                  onPressed: () {
                    if (_signal.getCategory.toString() == "eatSignal") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotFirstSenderEatSignal()));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotFirstSenderPlaySignal()));
                    }
                  },
                )
          ],
        ),
      ),
    );
  }
}
