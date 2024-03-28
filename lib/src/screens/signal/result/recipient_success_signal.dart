import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/signal/result/signal_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipientSuccessSignal extends StatelessWidget {
  const RecipientSuccessSignal({Key? key}) : super(key: key);

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
                "시그널 매칭 성공",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30.0),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
            Center(
              child: const Icon(
                Icons.favorite,
                size: 100,
                color: const Color(0xffFE9BE6),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
            Center(
              child: Text(
                '시그널 성공을 축하합니다!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            TextButton(
              child: Text(
                '결과에 맞는 주변 검색하기',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffFE9BE6),
                minimumSize: Size.fromHeight(50)
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignalResult(resultItem: _signal.getResultSelected, category: _signal.getCategory,)));
              },
            ),
            SizedBox(height: 10.0,),
            TextButton(
              child: Text(
                '메인',
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
        ),
      ),
    );
  }
}
