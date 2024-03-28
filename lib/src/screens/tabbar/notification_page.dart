import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/notification/notification_dto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var _suggestions;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future fetchData;

  @override
  void initState() {
    fetchData = _getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'images/heartnal_bi.png',
          height: MediaQuery.of(context).size.height * 0.04,
          fit: BoxFit.contain,
        ),
      ),
      body: FutureBuilder(
        future: fetchData,
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
          } else if (snapshot.connectionState == ConnectionState.done && _suggestions.length == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    '데이터가 없어요.',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black),
                  ),
                )
              ],
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                // index 가 홀수인 경우 구분선 추가
                if (index.isOdd) {
                  const Divider();
                }
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        _suggestions[index].message.toString(),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black),
                      ),
                      subtitle: Text(
                        _suggestions[index].regDt.toString(),
                        // style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    const Divider()
                  ],
                );
              },
            );
          }
        },
      )
    );
  }

  _getNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/notification/${username}');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<NotificationDto> notificationList = ((json.decode(response.body) as List).map((e) => NotificationDto.fromJson(e)).toList());
    _suggestions = notificationList;

    return _suggestions;
  }
}
