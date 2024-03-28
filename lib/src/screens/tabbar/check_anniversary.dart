import 'package:couple_signal/src/models/anniversary/anniversary.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/screens/tabbar/update_anniversary.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CheckAnniversary extends StatefulWidget {
  final int anniversarySeq;
  final String anniversaryTitle;
  final String anniversaryDate;
  final String repeatYN;

  const CheckAnniversary({Key? key, required this.anniversarySeq, required this.anniversaryTitle, required this.anniversaryDate, required this.repeatYN}) : super(key: key);

  @override
  _CheckAnniversaryState createState() => _CheckAnniversaryState();
}

class _CheckAnniversaryState extends State<CheckAnniversary> {
  TextEditingController anniversaryTitleController = new TextEditingController();
  String datetime = "";
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    datetime = widget.anniversaryDate;
    anniversaryTitleController = new TextEditingController(text: widget.anniversaryTitle);
    _isChecked = (widget.repeatYN == "Y") ? true : false;
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
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) async {
              switch (result) {
                case '수정하기':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateAnniversary(
                              anniversarySeq: widget.anniversarySeq,
                              anniversaryTitle: widget.anniversaryTitle,
                              anniversaryDate: widget.anniversaryDate,
                              repeatYN: widget.repeatYN
                          )
                      )
                  );
                  break;
                case '삭제하기':
                  await checkDeleteAnniversary(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '수정하기',
                child: Text(
                  "수정하기",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem<String>(
                value: '삭제하기',
                child: Text(
                  "삭제하기",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Card(
                      elevation: 4.0,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/background_img.jpg"),
                                fit: BoxFit.cover
                            )
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "기념일 날짜",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: const SizedBox(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    datetime,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.16,
                    child: Card(
                      elevation: 4.0,
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/background_img.jpg"),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Text(
                                  '기념일 제목 설정하기',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.grey)
                                  ),
                                  margin: const EdgeInsets.all(0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      readOnly: true,
                                      controller: anniversaryTitleController,
                                      textInputAction: TextInputAction.done,
                                      style: Theme.of(context).textTheme.bodyText2,
                                      decoration: InputDecoration.collapsed(
                                        hintText: '제목을 입력해주세요!',
                                        hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                      ),
                                      maxLines: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      elevation: 4.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/background_img.jpg"),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = !_isChecked;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                        child: Text(
                                          '반복 설정 여부',
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          /// toggle isChecked
                                          _isChecked = !_isChecked;
                                        });
                                      }
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  checkDeleteAnniversary(BuildContext context) async {
    Anniversary _anniversary = Provider.of<Anniversary>(context, listen: false);
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "기념일 삭제",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '삭제 후에는 복구가 불가능해요.\n그래도 삭제할까요?',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '삭제',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            bool result = await _anniversary.deleteAnniversary(widget.anniversarySeq);
            if (result) {
              /// 성공 alert
              GlobalAlert().globDeleteSuccessAlert(context);
            } else {
              GlobalAlert().globErrorAlert(context);
            }
          },
        ),
        TextButton(
          child: Text(
            '취소',
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
}
