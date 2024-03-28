import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenstrualCycleFAQ extends StatelessWidget {
  const MenstrualCycleFAQ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "생리주기 캘린더 FAQ",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Card(
                      elevation: 0.0,
                      child: Container(
                        color: const Color(0xffFFF1F5),
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                            SizedBox(height: 10,),
                            Center(
                              child: Text(
                                "생리주기 캘린더에 대한\n궁금증을 해결해드려요!",
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5,),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                ),
              ),
              ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(
                    "생리주기 캘린더를 사용하려면 어떤 정보가 필요하나요?",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                leading: Icon(Icons.view_list),
                iconColor: const Color(0xffFE9BE6),
                textColor: const Color(0xffFE9BE6),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "하트널의 생리주기 캘린더를 사용하려면 '가장 최근 생리 시작일', '평균 생리 주기', '평균 생리 기간'의 데이터가 필요해요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
                ],
              ),
              ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(
                    "생리주기 캘린더는 어떤 정보를 제공하나요?",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                leading: Icon(Icons.view_list),
                iconColor: const Color(0xffFE9BE6),
                textColor: const Color(0xffFE9BE6),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "하트널의 생리주기 캘린더는 입력한 정보를 기반으로 '생리 예정일', '배란일', '가임기'를 제공해 드려요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
                ],
              ),
              ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(
                    "마지막 생리 시작일을 매월 변경해야 하나요?",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                leading: Icon(Icons.view_list),
                iconColor: const Color(0xffFE9BE6),
                textColor: const Color(0xffFE9BE6),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "아뇨! 처음 한 번만 등록하면 자동으로 날짜를 계산하여 생리주기 캘린더를 제공해 드려요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
                ],
              ),
              ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(
                    "남자친구도 캘린더를 볼 수 있나요?",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                leading: Icon(Icons.view_list),
                iconColor: const Color(0xffFE9BE6),
                textColor: const Color(0xffFE9BE6),
                children: [
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "네, 생리주기 캘린더는 커플인 두 사람 모두에게 공유가 되는 캘린더에요!",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      )
                  )
                ],
              ),
              ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(
                    "남자친구에게도 알림이 가나요?",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                leading: Icon(Icons.view_list),
                iconColor: const Color(0xffFE9BE6),
                textColor: const Color(0xffFE9BE6),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "네, 생리주기 캘린더 설정 페이지를 통해 본인뿐 아니라 상대방에게도 알림을 제공하며 알림 메시지를 직접 설정도 가능해요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
                ],
              ),
              ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(
                    "남자친구가 생리주기를 설정해버렸어요",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                leading: Icon(Icons.view_list),
                iconColor: const Color(0xffFE9BE6),
                textColor: const Color(0xffFE9BE6),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "남성분이 생리주기를 설정한 경우 [생리주기 캘린더 메인] 우측 상단 [생리주기 설정] 메뉴의 [생리주기 초기화]를 통해 설정을 초기화할 수 있어요. 이후 여성분이 다시 생리주기를 설정하면 돼요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
                ],
              ),
              ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(
                    "생리주기 설정도 공유되나요?",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                leading: Icon(Icons.view_list),
                iconColor: const Color(0xffFE9BE6),
                textColor: const Color(0xffFE9BE6),
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "아뇨! 생리주기 설정은 기존에 데이터를 입력한 분에게 권한이 주어져요! 권한이 없는 분은 접근이 불가능해요!",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}

