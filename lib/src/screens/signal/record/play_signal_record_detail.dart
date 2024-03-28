import 'package:couple_signal/src/screens/signal/record/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/global/global_variable.dart';
import '../../../models/signal/recent_signal.dart';
import '../../../models/theme/theme_provider.dart';

int _playSignalRecentCount = 0;
int _playSignalRecentSuccessCount = 0;
int _memberSeq = 0;
String datetime = "";
List<RecentSignal> playSignalList = [];
List<RecentSignal> oneWeekList = [];
List<RecentSignal> oneMonthList = [];
List<RecentSignal> threeMonthList = [];
List<RecentSignal> selectList = [];
bool _isEmpty = false;

class PlaySignalRecordDetail extends StatefulWidget {
  const PlaySignalRecordDetail({Key? key}) : super(key: key);

  @override
  State<PlaySignalRecordDetail> createState() => _PlaySignalRecordDetailState();
}

class _PlaySignalRecordDetailState extends State<PlaySignalRecordDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getMemberSeq();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    RecentSignal _recentSignal = Provider.of<RecentSignal>(context, listen: false);
    List<RecentSignal> allPlaySignalList = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오늘 뭐하지 이력보기',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Color(0xffFFF7F3),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFF7F3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        '오늘 뭐하지 최근 20개 결과',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    FutureBuilder(
                      future: _recentSignal.getRecentSignal(),
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
                          // recentSignal = snapshot.data;
                          _playSignalRecentCount = _recentSignal.getPlaySignalRecentCount;
                          _playSignalRecentSuccessCount = _recentSignal.getPlaySignalRecentSuccessCount;
                          return Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      child: CustomPaint(
                                        size: Size(MediaQuery.of(context).size.width * 0.30, MediaQuery.of(context).size.height * 0.15),
                                        painter: PieChart(
                                            percentage: _playSignalRecentSuccessCount,
                                            textScaleFactor: 1.0,
                                            textColor: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
              Divider(),
              FutureBuilder(
                future: _recentSignal.getAllSignalList('playSignal'),
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
                    allPlaySignalList = snapshot.data;
                    if (allPlaySignalList.isEmpty || snapshot.data == null) {
                      _isEmpty = true;
                    }
                    playSignalList = snapshot.data;

                    /// 여기서 1주일, 1개월, 3개월, 그리고 날짜 선택에 쓸 리스트들을 만들어줘야함
                    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

                    /// 초기화
                    oneWeekList = [];
                    oneMonthList = [];
                    threeMonthList = [];

                    for (var i = 0; i < allPlaySignalList.length; i++) {
                      int diff = now.difference(DateTime.parse(allPlaySignalList[i].regDt.toString().substring(0, 10))).inDays;

                      if (-1 < diff && diff < 8) {
                        oneWeekList.add(allPlaySignalList[i]);
                        oneMonthList.add(allPlaySignalList[i]);
                        threeMonthList.add(allPlaySignalList[i]);
                      } else if (7 < diff && diff < 31) {
                        oneMonthList.add(allPlaySignalList[i]);
                        threeMonthList.add(allPlaySignalList[i]);
                      } else if (30 < diff && diff < 91) {
                        threeMonthList.add(allPlaySignalList[i]);
                      }
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            labelColor: const Color(0xffFE9BE6),
                            isScrollable: true,
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: Colors.grey,
                            unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "1주일",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "1개월",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "3개월",
                                ),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    "기간 선택",
                                  ),
                                ),
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

                                      for (var i = 0; i < playSignalList.length; i++) {
                                        DateTime diff = DateTime.parse(playSignalList[i].regDt.toString().substring(0, 10));
                                        for (var j = 0; j < daysInBetweenList.length; j++) {
                                          if (diff == daysInBetweenList[j]) {
                                            selectList.add(playSignalList[i]);
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
                                          "오늘 뭐먹지 시그널을 보내주세요!",
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
                                          "오늘 뭐먹지 시그널을 보내주세요!",
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
                                          "오늘 뭐먹지 시그널을 보내주세요!",
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
                                          "오늘 뭐먹지 시그널을 보내주세요!",
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
                                _cardView(context, oneWeekList, 'oneWeek'),
                                _cardView(context, oneMonthList, 'oneMonth'),
                                _cardView(context, threeMonthList, 'threeMonth'),
                                _cardView(context, selectList, 'select'),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  _cardView(BuildContext context, List<RecentSignal> list, String period ) {
    RecentSignal _recentSignal = Provider.of<RecentSignal>(context, listen: false);
    String periodTitle = '';
    String categoryTitle = '';
    String signalCount = '';
    String signalSuccessRate = '';
    String sentSignalCount = '';
    String receivedSignalCount = '';
    String mostMatchedSignal = '';

    switch (period) {
      case 'oneWeek':
        periodTitle = '최근 1주일';
        break;
      case 'oneMonth':
        periodTitle = '최근 1달';
        break;
      case 'threeMonth':
        periodTitle = '최근 3달';
        break;
      case 'select':
        if (list.length == 0) {
          periodTitle = '';
        } else {
          String firstDt = list.first.regDt.toString().substring(0, 10);
          String lastDt = list.last.regDt.toString().substring(0, 10);

          periodTitle = '$firstDt ~ $lastDt';
        }
        break;
    }

    int successSignal = 0;
    int sentSignal = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].finalResult == '1') {
        successSignal++;
      }
      if (list[i].senderMemberSeq == _memberSeq) {
        sentSignal++;
      }
    }

    if (list.length == 0) {
      signalCount = '0건';
      signalSuccessRate = '0.00%';
    } else {
      signalCount = list.length.toString() + '건';
      signalSuccessRate = ((successSignal / list.length) * 100).toStringAsFixed(2) + '%';
    }

    sentSignalCount = sentSignal.toString() + '건';
    receivedSignalCount = (list.length - sentSignal).toString() + '건';


    if (list.length == 0) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            (period == 'select') ?
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0 , 10, 10),
                child: Text(
                    '$periodTitle'
                ),
              ),
            ) :
            SizedBox(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    padding: EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFF7F3),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                              '시그널 건수'
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                        Center(
                          child: Text(
                              '$signalCount'
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    padding: EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFF7F3),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('시그널 성공률'),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                        Center(
                          child: Text(
                              '$signalSuccessRate'
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    padding: EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFF7F3),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('내가 보낸 시그널'),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                        Center(
                          child: Text(
                              '$sentSignalCount'
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    padding: EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFF7F3),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('내가 받은 시그널'),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                        Center(
                          child: Text(
                              '$receivedSignalCount'
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    padding: EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFF7F3),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text('최다 매칭 시그널'),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                        Center(
                          child: Text(
                              '없음'
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return FutureBuilder(
          future: _recentSignal.getMostMatchedSignalItem('playSignal', list.first.regDt.toString().substring(0, 10), list.last.regDt.toString().substring(0, 10)),
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
              RecentSignal recentSignal = snapshot.data;
              return Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    (period == 'select') ?
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0 , 10, 10),
                        child: Text(
                            '$periodTitle'
                        ),
                      ),
                    ) :
                    SizedBox(),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            padding: EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFF7F3),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                      '시그널 건수'
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                Center(
                                  child: Text(
                                      '$signalCount'
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            padding: EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFF7F3),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Text('시그널 성공률'),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                Center(
                                  child: Text(
                                      '$signalSuccessRate'
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            padding: EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFF7F3),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Text('내가 보낸 시그널'),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                Center(
                                  child: Text(
                                      '$sentSignalCount'
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            padding: EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFF7F3),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Text('내가 받은 시그널'),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                Center(
                                  child: Text(
                                      '$receivedSignalCount'
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            padding: EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFF7F3),
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: Text('최다 매칭 시그널'),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                Center(
                                  child: Text(
                                      (recentSignal.mostMatchedSignalItem.toString() == 'null') ? '없음' : recentSignal.mostMatchedSignalItem.toString()
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }
      );
    }
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
