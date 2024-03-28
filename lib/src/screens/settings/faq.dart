import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

// FAQ
class FAQ extends StatelessWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "FAQ",
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
                                child: Lottie.asset(
                                  'images/json/icon/icon_signal.json',
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.height * 0.09
                                ),
                              ),
                              SizedBox(height: 10,),
                              Center(
                                child: Text(
                                  "하트널에 대한\n궁금증을 해결해드려요!",
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5,),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                ),
                /// 1번 질문
                ExpansionTile(
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      "하트널은 어떤 앱인가요?",
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
                            "하트널은 오늘 뭐먹지? 오늘 뭐하지 등의 시그널을 통해 서로의 마음을 알아보는 커플들을 위한 앱이에요! \n시그널 기능 외에 D-Day, 커플 다이어리, 커플 공용 캘린더 등 커플들을 위한 다양한 기능을 제공하고 있어요!",
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
                      "하트널은 무료인가요?",
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
                            "네! 하트널은 모든 기능을 무료로 제공하고 있어요!",
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
                      "커플이 아니면 사용하는데 제한이 있나요?",
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
                          "네 아쉽지만 하트널은 커플 전용 앱이기 때문에 커플이 아닌 경우 특정 기능들의 사용에 제한이 있을 수 있어요.",
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
                      "친구랑 사용해도 되나요?",
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
                          "네, 저희는 커플들을 위한 앱으로 만들었지만 무조건 남녀만 커플이 연동되는 것은 아니기에 친구끼리 사용하는 것도 가능해요!",
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
                      "홧김에 커플 연동 해제했는데 복구가 가능한가요?",
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
                            "네, 기존 커플이었던 두 분 중 한 분이 커플 코드를 다시 생성 후 상대방에게 전달 및 커플 연동을 진행하시면 다시 기존 데이터가 복구돼요! \n다만, 30일이 지난 경우 복구가 어려울 수 있어요!",
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
                      "시그널을 보냈는데 알림이 오지 않아요",
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
                            "앱을 최신버전으로 업데이트 하지 않을 경우 푸시 알림이 정상적으로 작동하지 않을 수 있어요! 앱스토어/플레이스토어에서 앱 업데이트를 진행해주세요! \n혹시나 그래도 알림이 오지 않는다면 앱 삭제 후 재설치나 1:1문의를 이용해주세요!",
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
                      "광고 제거도 가능한가요?",
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
                            "아쉽지만 아직은 광고 제거가 불가능해요! 추후 업데이트에 광고 제거 기능을 추가할 예정이니 조금만 기다려주세요!",
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
