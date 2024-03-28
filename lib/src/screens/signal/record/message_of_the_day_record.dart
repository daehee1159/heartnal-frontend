import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day_dto.dart';
import 'package:couple_signal/src/models/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _memberSeq = 0;
String datetime = "";
List<MessageOfTheDayDto> messageList = [];
List<MessageOfTheDayDto> oneWeekList = [];
List<MessageOfTheDayDto> oneMonthList = [];
List<MessageOfTheDayDto> threeMonthList = [];
List<MessageOfTheDayDto> selectList = [];
bool _isEmpty = false;

class MessageOfTheDayRecord extends StatefulWidget {
  const MessageOfTheDayRecord({Key? key}) : super(key: key);

  @override
  State<MessageOfTheDayRecord> createState() => _MessageOfTheDayRecordState();
}

class _MessageOfTheDayRecordState extends State<MessageOfTheDayRecord> with SingleTickerProviderStateMixin {
  List<MessageOfTheDayDto> messageOfTheDayList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getMemberSeq();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);
    var recordItemList = _messageOfTheDay.getRecordItemList;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "오늘의 한마디 이력보기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: _messageOfTheDay.getMessageOfTheDay(),
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
            messageOfTheDayList = snapshot.data;
            if (messageOfTheDayList.isEmpty || snapshot.data == null) {
              _isEmpty = true;
            }
            messageList = snapshot.data;

            /// 여기서 1주일, 1개월, 3개월, 그리고 날짜 선택에 쓸 리스트들을 만들어줘야함
            DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

            /// 초기화
            oneWeekList = [];
            oneMonthList = [];
            threeMonthList = [];

            for (var i = 0; i < messageOfTheDayList.length; i++) {
              int diff = now.difference(DateTime.parse(messageOfTheDayList[i].regDt.toString().substring(0, 10))).inDays;

              if (-1 < diff && diff < 8) {
                oneWeekList.add(messageOfTheDayList[i]);
                oneMonthList.add(messageOfTheDayList[i]);
                threeMonthList.add(messageOfTheDayList[i]);
              } else if (7 < diff && diff < 31) {
                oneMonthList.add(messageOfTheDayList[i]);
                threeMonthList.add(messageOfTheDayList[i]);
              } else if (30 < diff && diff < 91) {
                threeMonthList.add(messageOfTheDayList[i]);
              }
            }

            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xffFE9BE6),
                      isScrollable: true,
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
                      labelStyle: Theme.of(context).textTheme.bodyText2,
                      tabs: [
                        Text(
                          "1주일",
                        ),
                        Text(
                          "1개월",
                        ),
                        Text(
                          "3개월",
                        ),
                        InkWell(
                          child: Text("기간 선택"),
                          onTap: () async {
                            DateTime currentDate = DateTime.now();
                            bool isCanceled = true;

                            ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context, listen: false);

                            Future<void> _selectDate(BuildContext context) async {
                              final DateTimeRange? pickedDate = await showDateRangePicker(
                                context: context,
                                currentDate: DateTime.now(),
                                locale: Locale('ko'),
                                helpText: "",
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2050),
                                saveText: "선택",
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: _themeProvider.themeData(_themeProvider.darkTheme).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Color(0xffFE9BE6),
                                        onPrimary: Colors.black,
                                      ),
                                      dialogBackgroundColor:Colors.white,
                                    ),
                                    child: child as Widget,
                                  );
                                },
                              );
                              /// (pickedDate == null) = 취소 버튼 누름
                              if (pickedDate == null) {
                                isCanceled = false;
                              } else {
                                datetime = pickedDate.toString().substring(0, 10);

                                DateTime startDate = DateTime(pickedDate.start.year, pickedDate.start.month, pickedDate.start.day);
                                DateTime endDate = DateTime(pickedDate.end.year, pickedDate.end.month, pickedDate.end.day);

                                List<DateTime> daysInBetweenList = getDaysInBetween(startDate, endDate);

                                /// 초기화
                                selectList = [];

                                for (var i = 0; i < messageList.length; i++) {
                                  DateTime diff = DateTime.parse(messageList[i].regDt.toString().substring(0, 10));
                                  for (var j = 0; j < daysInBetweenList.length; j++) {
                                    if (diff == daysInBetweenList[j]) {
                                      selectList.add(messageList[i]);
                                    }
                                  }
                                }
                              }
                            }
                            await _selectDate(context);
                            setState(() {
                              _tabController.index = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  (_isEmpty) ?
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "기록이 존재하지 않아요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Center(
                                child: Text(
                                  "첫 오늘의 한마디를 보내주세요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "기록이 존재하지 않아요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Center(
                                child: Text(
                                  "첫 오늘의 한마디를 보내주세요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "기록이 존재하지 않아요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Center(
                                child: Text(
                                  "첫 오늘의 한마디를 보내주세요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "기록이 존재하지 않아요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Center(
                                child: Text(
                                  "첫 오늘의 한마디를 보내주세요!",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ) :
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              (oneWeekList.length == 0) ?
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "최근 기록이 존재하지 않아요!",
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                              ) :
                              Expanded(
                                child: ListView.builder(
                                  itemCount: oneWeekList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      height: MediaQuery.of(context).size.height * 0.23,
                                      child: Card(
                                          elevation: 4.0,
                                          child: Container(
                                            // color: const Color(0xffFFF1F5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    color: _memberSeq == oneWeekList[index].senderMemberSeq ? Colors.blue : const Color(0xffFE9BE6),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 13,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          right: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1.0,
                                                          )
                                                        )
                                                      ),
                                                      child: _memberSeq == oneWeekList[index].senderMemberSeq ?
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Spacer(),
                                                          (_myProfileInfo.myProfileImgAddr.toString() == 'null') ?
                                                          CircleAvatar(
                                                            radius: MediaQuery.of(context).size.width * 0.07,
                                                            backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                                          ) :
                                                          CircleAvatar(
                                                            radius: MediaQuery.of(context).size.width * 0.07,
                                                            backgroundImage: NetworkImage(_myProfileInfo.getMyProfileImgUrl),
                                                          ),
                                                          SizedBox(height: 10.0,),
                                                          Text(
                                                            _myProfileInfo.nickName.toString(),
                                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            oneWeekList[index].regDt.toString().substring(0, 10),
                                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                                          ),
                                                          SizedBox(height: 10.0,)
                                                        ],
                                                      ) :
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Spacer(),
                                                          (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                                                          CircleAvatar(
                                                            radius: MediaQuery.of(context).size.width * 0.07,
                                                            backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                                          ) :
                                                          CircleAvatar(
                                                            radius: MediaQuery.of(context).size.width * 0.07,
                                                            backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                                                          ),
                                                          SizedBox(height: 10.0,),
                                                          Text(
                                                            _myProfileInfo.coupleNickName.toString(),
                                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                                          ),
                                                          Spacer(),
                                                          Text(
                                                            oneWeekList[index].regDt.toString().substring(0, 10),
                                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                                          ),
                                                          SizedBox(height: 10.0,)
                                                        ],
                                                      )
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 37,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Text(
                                                            oneWeekList[index].message.toString(),
                                                            style: Theme.of(context).textTheme.bodyText2,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          onTap: () {

                          },
                        ),
                        _cardView(context, oneMonthList),
                        _cardView(context, threeMonthList),
                        _cardView(context, selectList),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        }
      )
    );
  }

  _cardView(BuildContext context, List<MessageOfTheDayDto> list) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    return GestureDetector(
      child: Column(
        children: [
          (list.length == 0) ?
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "최근 기록이 존재하지 않아요!",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ) :
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: Card(
                      elevation: 4.0,
                      child: Container(
                        // color: const Color(0xffFFF1F5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: _memberSeq == list[index].senderMemberSeq ? Colors.blue : const Color(0xffFE9BE6),
                              ),
                            ),
                            Expanded(
                              flex: 13,
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          )
                                      )
                                  ),
                                  child: _memberSeq == messageOfTheDayList[index].senderMemberSeq ?
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
                                      (_myProfileInfo.myProfileImgAddr.toString() == 'null') ?
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.width * 0.07,
                                        backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                      ) :
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.width * 0.07,
                                        backgroundImage: NetworkImage(_myProfileInfo.getMyProfileImgUrl),
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                        _myProfileInfo.nickName.toString(),
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        list[index].regDt.toString().substring(0, 10),
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                      ),
                                      SizedBox(height: 10.0,)
                                    ],
                                  ) :
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
                                      (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.width * 0.07,
                                        backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                      ) :
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.width * 0.07,
                                        backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                        _myProfileInfo.coupleNickName.toString(),
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        list[index].regDt.toString().substring(0, 10),
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                      ),
                                      SizedBox(height: 10.0,)
                                    ],
                                  )
                              ),
                            ),
                            Expanded(
                              flex: 37,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        list[index].message.toString(),
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                );
              },
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  _getMemberSeq() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    _memberSeq = memberSeq;
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    String realMonth = "";
    String realDay = "";

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime date = startDate.add(Duration(days: i));

      if (date.month < 10) {
        realMonth = "0" + date.month.toString();
      } else {
        realMonth = date.month.toString();
      }

      if ((date.day) < 10) {
        realDay = "0" + (date.day).toString();
      } else {
        realDay = (date.day).toString();
      }

      days.add(DateTime.parse(date.year.toString() + "-" + realMonth + "-" + realDay));
    }
    return days;
  }
}
