import 'package:couple_signal/src/models/couple_diary/couple_diary.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/screens/diary/update_couple_diary.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _writerNickName = "";
String _writerProfileImgAddr = "";

class CoupleDiaryDetailPage extends StatefulWidget {
  final int diarySeq;
  final int writerMemberSeq;
  final List<String> imgList;
  final String contents;
  final String datetime;
  const CoupleDiaryDetailPage({Key? key,required this.diarySeq, required this.writerMemberSeq,required this.imgList, required this.contents, required this.datetime}) : super(key: key);

  @override
  _CoupleDiaryDetailPageState createState() => _CoupleDiaryDetailPageState();
}

class _CoupleDiaryDetailPageState extends State<CoupleDiaryDetailPage> {
  static const String update = "수정하기";
  static const String delete = "삭제하기";
  static const List<String> choices = <String>[update, delete];
  String choiceString = "";

  int _current = 0;
  String firstHalf = "";
  String secondHalf = "";

  bool flag = true;
  bool descTextShowFlag = false;

  @override
  void initState() {
    super.initState();
    if (widget.contents.length > 50) {
      firstHalf = widget.contents.substring(0, 50);
      secondHalf = widget.contents.substring(50, widget.contents.length);
    } else {
      firstHalf = widget.contents;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    CoupleDiary _coupleDiaryProvider = Provider.of<CoupleDiary>(context, listen: false);

    final List<Widget> imageSliders = widget.imgList.map((item) => Container(
      child: ClipRRect(
        child: Stack(
          children: [
            Image.network(
              item,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.height * 1.0,
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(0, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            )
          ],
        ),
      ),
    )).toList();

    final Storage storage = Storage();
    int? likeCount = _coupleDiaryProvider.likeCount;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 1,)));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 1,)));
            },
          ),
          title: Text(
            '커플 다이어리',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                            future: _fetchData(context, widget.writerMemberSeq),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Error',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                );
                              } else {
                                return Row(
                                  children: [
                                    (snapshot.data.toString() == "null") ?
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: CircleAvatar(
                                          radius: MediaQuery.of(context).size.width * 0.05,
                                          backgroundImage: const AssetImage('images/basic_profile_img.jpg')
                                      ),
                                    ) :
                                    FutureBuilder(
                                      future: storage.downloadURL(snapshot.data.toString(), "profile"),
                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: CircleAvatar(
                                              radius: MediaQuery.of(context).size.width * 0.05,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data!
                                              ),
                                            ),
                                          );
                                        } else if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    Text(
                                      _writerNickName,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      FontAwesomeIcons.ellipsisH,
                                    ),
                                    onSelected: (result) async {
                                      bool checkedAuthority = await _coupleDiaryProvider.checkCoupleDiaryAuthority(widget.diarySeq);

                                      if (checkedAuthority) {
                                        if (result == update) {
                                          List<String> imgNameList = [];
                                          switch (_coupleDiaryProvider.getFileCount) {
                                            case 1:
                                              imgNameList.add(_coupleDiaryProvider.getFileName1.toString());
                                              break;
                                            case 2:
                                              imgNameList.add(_coupleDiaryProvider.getFileName1.toString());
                                              imgNameList.add(_coupleDiaryProvider.getFileName2.toString());
                                              break;
                                            case 3:
                                              imgNameList.add(_coupleDiaryProvider.getFileName1.toString());
                                              imgNameList.add(_coupleDiaryProvider.getFileName2.toString());
                                              imgNameList.add(_coupleDiaryProvider.getFileName3.toString());
                                              break;
                                          }
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateCoupleDiary(imgNameList: imgNameList, diarySeq: widget.diarySeq, datetime: widget.datetime, contents: widget.contents, imgList: widget.imgList)));
                                        } else if (result == delete) {
                                          /// 재확인 alert
                                          _confirmAlertDialog(context, widget.imgList, widget.diarySeq);
                                        }
                                      } else {
                                        /// 권한 없음 alert
                                        _hasNotAuthorityAlertDialog(context);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return choices.map((String choice) {
                                        choiceString = choice;
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(
                                            "- " + choice,
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  )
                                ),
                              ],
                            )
                        )
                      ],
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    widget.datetime,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
                (imageSliders.length == 1) ?
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.height * 0.40,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }
                  ),
                ) :
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.height * 0.40,
                      autoPlay: false,
                      enlargeCenterPage: false,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }
                  ),
                ),
                (imageSliders.length == 1) ?
                SizedBox() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imgList.map((url) {
                    int index = widget.imgList.indexOf(url);
                    return Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: (_coupleDiaryProvider.likeCount == 0) ? const Icon(
                        Icons.favorite_outline,
                        size: 30,
                        color: const Color(0xffFE9BE6),
                      ) :
                      const Icon(
                        Icons.favorite,
                        size: 30,
                        color: const Color(0xffFE9BE6),
                      ),
                      onPressed: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        int? memberSeq = pref.getInt(Glob.memberSeq);

                        if (_coupleDiaryProvider.likeCount == 0) {
                          // 좋아요 API
                          bool result = await _coupleDiaryProvider.pressLike(widget.diarySeq);
                          if (result) {
                            setState(() {
                              _coupleDiaryProvider.setLikeCount = int.parse(_coupleDiaryProvider.likeCount.toString()) + 1;
                            });
                          } else {
                            GlobalAlert().globErrorAlert(context);
                          }
                        } else {
                          if (_coupleDiaryProvider.getLikeMember1 == memberSeq || _coupleDiaryProvider.getLikeMember2 == memberSeq) {
                            // 이미 내가 좋아요를 누른 상태니까 API 호출하면 안됨
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '이미 좋아요를 누른 게시물이에요!',
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              )
                            );
                          } else {
                            // 상대방은 이미 좋아요 누른 상태이며 나는 아직 안누른 상태니까 API 호출
                            bool result = await _coupleDiaryProvider.pressLike(widget.diarySeq);
                            if (result) {
                              setState(() {

                              });
                            } else {
                              GlobalAlert().globErrorAlert(context);
                            }
                          }
                        }
                      },
                    ),
                    Text(
                      '좋아요 $likeCount개',
                      style: Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contents,
                        maxLines: descTextShowFlag ? 100 : 1,
                        textAlign: TextAlign.start,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            descTextShowFlag = !descTextShowFlag;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            descTextShowFlag ? Text("줄이기",style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),) :  Text("더 보기",style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _fetchData(BuildContext context, int writerMemberSeq) async {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    if (writerMemberSeq == int.parse(memberSeq.toString())) {
      _writerNickName = _myProfileInfo.nickName.toString();
      _writerProfileImgAddr = _myProfileInfo.myProfileImgAddr.toString();
      return _writerProfileImgAddr;
    } else {
      _writerNickName = _myProfileInfo.coupleNickName.toString();
      _writerProfileImgAddr = _myProfileInfo.coupleProfileImgAddr.toString();
      return _writerProfileImgAddr;
    }
  }

  _confirmAlertDialog(BuildContext context, List<String> deleteImageList, int diarySeq) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "다이어리 삭제",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        "삭제 후 복구가 불가능해요.\n그래도 삭제할까요?",
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            Storage storage = new Storage();
            CoupleDiary _coupleDiaryProvider = Provider.of<CoupleDiary>(context, listen: false);

            List<String> deleteImgList = [];
            switch (_coupleDiaryProvider.getFileCount) {
              case 1:
                deleteImgList.add(_coupleDiaryProvider.getFileName1.toString());
                break;
              case 2:
                deleteImgList.add(_coupleDiaryProvider.getFileName1.toString());
                deleteImgList.add(_coupleDiaryProvider.getFileName2.toString());
                break;
              case 3:
                deleteImgList.add(_coupleDiaryProvider.getFileName1.toString());
                deleteImgList.add(_coupleDiaryProvider.getFileName2.toString());
                deleteImgList.add(_coupleDiaryProvider.getFileName3.toString());
                break;
            }

            bool deleteResult = await storage.deleteFile(deleteImgList, "couple_diary");

            if (deleteResult) {
              bool result = await _coupleDiaryProvider.deleteCoupleDiary(diarySeq);
              if (result) {
                Navigator.of(context).pop();
                return deleteSuccessAlert(context);
              } else {
                return _failureAlertDialog(context);
              }
            } else {
              return _failureAlertDialog(context);
            }

          },
        ),
        TextButton(
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
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

  _failureAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "오류",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        "알 수 없는 오류 발생!\n잠시 후 다시 시도해주세요.",
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
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

  _hasNotAuthorityAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "수정 및 삭제 불가",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        "수정 및 삭제 권한은\n다이어리 작성자에게만 있습니다!",
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
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

  deleteSuccessAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "삭제 성공",
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
        '삭제에 성공했어요.',
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 1,)));
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
