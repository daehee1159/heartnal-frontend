import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenstrualCycleInfo extends StatelessWidget {
  const MenstrualCycleInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  "여성 생리에 대한 기초지식",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30.0),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Text(
                  "여성뿐 아니라 남성에게도 필요한 지식이에요!",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5, color: Colors.grey),
                )
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/calendar/menstrual_cycle.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).size.height * 0.05, 0, 0),
                child: Text(
                  "생리란?",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25.0),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Text(
                  "임신이 가능할 만큼 성숙한 여성의 자궁에서 자궁 오염 방지 및 보호를 위해 주기적으로 출혈과 통증이 일어나는 생리 현상이에요.",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8, fontWeight: FontWeight.w500),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).size.height * 0.05, 0, 0),
                child: Text(
                  "생리 기간",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25.0),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Text(
                  "정상 생리의 주기는 초경 후 첫 2년간은 대부분 무배란성 주기로 21~40일 간격이며 이후 대부분 21~35일로 정착되며 평균 생리 기간은 2~6일, 주기 당 출혈량은 약 20~60ml 정도에요."
                  "초경 2년이 지난 후에도 주기가 35일 이상이거나 21일 이하인 경우, 생리 기간이 7일 이상 지속되는 경우는 비정상 생리로 간주할 수 있어요.",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8, fontWeight: FontWeight.w500),
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/calendar/ovulation.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).size.height * 0.05, 0, 0),
                child: Text(
                  "배란이란?",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25.0),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Text(
                  "난소에서 성숙한 난자가 배출되는 현상이며 수정과 착상 그리고 임신, 출산을 위한 신체 내의 사전 준비라고 할 수 있어요. 보통 배란된 난자의 수정 능력은 18 ~ 24시간 정도에요.",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8, fontWeight: FontWeight.w500),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).size.height * 0.05, 0, 0),
                child: Text(
                  "배란일",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25.0),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Text(
                  "성숙된 난포가 파괴되어 난자를 배출하는 시기에요. 성숙해진 난자는 배란이 진행되어 자궁에 있다가 약 24시간 생존이 가능해요. 그리고 24시간가량 지나면 퇴화하여 월경혈과 함께 몸 밖으로 버려져요."
                  "보통 배란일은 생리 예정일로부터 14일 전이에요.",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8, fontWeight: FontWeight.w500),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).size.height * 0.05, 0, 0),
                child: Text(
                  "가임기",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25.0),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Text(
                  "임신이 가능하다는 뜻으로, 월경 주기와 관련하여 임신이 가능한 기간 대개 28일 월결주기를 기준으로 생리 시작 14일 전부터 약 3일간이에요. 정자와 난자가 살아있는 시간을 고려하여 배란일 앞으로 5일, 뒤로 3일을 가임기로 볼 수 있어요.",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8, fontWeight: FontWeight.w500),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
