import 'package:couple_signal/src/screens/home.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오류',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                child: Text(
                  'Home',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xffFE9BE6)
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
