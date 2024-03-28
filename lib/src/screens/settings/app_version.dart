import 'dart:io';

import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '버전 정보',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: FutureBuilder(
        future: _myProfileInfo.getPackageInfo(Platform.isIOS ? "iOS" : "android"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator()
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          } else {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/heartnal_bi.png',
                      height: MediaQuery.of(context).size.height * 0.06,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Center(
                      child: Text(
                        snapshot.data['version'].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      snapshot.data['comment'].toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
