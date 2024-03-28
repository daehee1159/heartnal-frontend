// 1:1 문의하기
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/inquiry/inquiry.dart';
import 'package:couple_signal/src/models/inquiry/inquiry_dto.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OneOnOneInquiry extends StatefulWidget {
  const OneOnOneInquiry({Key? key}) : super(key: key);

  @override
  State<OneOnOneInquiry> createState() => _OneOnOneInquiryState();
}

class _OneOnOneInquiryState extends State<OneOnOneInquiry> with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _textController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  String _selectedInquiryType = "유형 선택";

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _textController = new TextEditingController();
    _titleController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Inquiry _inquiryProvider = Provider.of<Inquiry>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '1:1 문의하기',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      // resizeToAvoidBottomInset: true,
      body: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffD3D3D3)
                  ),
                  bottom: BorderSide(
                    color: Color(0xffD3D3D3)
                  )
                ),
                // color: Colors.grey
              ),
              child: TabBar(
                tabs: [
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '문의하기',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '문의 내역 보기',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicatorColor: const Color(0xffFE9BE6),

                controller: _tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '문의 제목',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            // padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: '제목을 입력해주세요!',
                                hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '문의 내용',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height * 0.32,
                            decoration: BoxDecoration(
                              border: Border.all()
                            ),
                            child: TextField(
                              textInputAction: TextInputAction.newline,
                              controller: _textController,
                              style: Theme.of(context).textTheme.bodyText2,
                              decoration: InputDecoration.collapsed(
                                hintText: '문의 내용을 입력해주세요!\n \n오류 제보, 기능 개선 등 어떠한 문의도 가능해요!',
                                hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                              ),
                              maxLines: 15,
                              maxLength: 700,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Center(
                            child: TextButton(
                              child: Text(
                                '문의하기',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                minimumSize: Size(MediaQuery.of(context).size.width * 0.3, 45),
                                backgroundColor: const Color(0xffFE9BE6),
                              ),
                              onPressed: () async {
                                if (_titleController.text == "" || _titleController.text.isEmpty) {
                                  /// 제목 미입력 alert
                                  _noInputAlert(context, "제목");
                                } else if (_textController.text == "" || _textController.text.isEmpty) {
                                  /// 내용 미입력 alert
                                  _noInputAlert(context, "내용");
                                } else {
                                  bool result = await _inquiryProvider.setInquiry(_titleController.text, _textController.text);

                                  if (result) {
                                    /// 성공 alert
                                    GlobalAlert().onLoading(context);
                                    await Future.delayed(Duration(seconds: 2));
                                    Navigator.of(context).pop();
                                    _sendSuccessAlert(context);
                                  } else {
                                    /// 실패 alert 
                                    GlobalAlert().globErrorAlert(context);
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.04, 0, 0),
                            child: Center(
                              child: Text(
                                '문의 내용에 따라\n답변에 소요되는 시간이 길어질 수 있으며\n답변이 완료되면 푸시알림으로 알려드려요!',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black38),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  SingleChildScrollView(
                    child: FutureBuilder(
                      future: _inquiryProvider.getInquiryList(),
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
                          List<InquiryDto> list = snapshot.data;

                          if (list.length == 0 || snapshot.data.length == 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  child: Center(
                                    child: Text(
                                      "문의 내역이 없어요!",
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,

                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return ExpansionTile(
                                  title: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                    child: Text(
                                      list[index].inquiryTitle.toString(),
                                      style: Theme.of(context).textTheme.bodyText2,
                                      textAlign: TextAlign.start,
                                      textDirection: TextDirection.ltr,
                                    ),
                                  ),
                                  subtitle: Text(
                                    list[index].inquiryDt.toString().substring(0, 10),
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                    textAlign: TextAlign.start,
                                    textDirection: TextDirection.ltr,
                                  ),
                                  leading: Icon(Icons.view_list),
                                  iconColor: const Color(0xffFE9BE6),
                                  textColor: const Color(0xffFE9BE6),
                                  children: [
                                    Divider(color: Colors.grey),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "질문 내용",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                                          textAlign: TextAlign.start,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      )
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          list[index].inquiries.toString(),
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ),
                                    Divider(color: Colors.black),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "답변 내용",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          (list[index].answerContent.toString() == "null") ? "답변을 기다리는 중이에요!" : list[index].answerContent.toString(),
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    )
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  _noInputAlert(BuildContext context, String category) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "$category 미입력",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
          Text(
            '문의 $category을 입력해 주세요!',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  _sendSuccessAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "문의하기 완료",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleCheck,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '문의하기가 완료되었어요!\n답변은 푸시알림으로 알려드려요!',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }
}
