import 'package:couple_signal/src/models/expression/expression.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/models/theme/theme_provider.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/splash_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:couple_signal/src/service/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

String testData = 'smileBeam';
late Widget list;
late Widget list2;
late Widget myExpression;
late String myExpressionText;
late Widget coupleExpression;
late String coupleExpressionText;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalAlert globalAlert = new GlobalAlert();
  final Storage storage = Storage();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];
  firebase_storage.FirebaseStorage _storageRef = firebase_storage.FirebaseStorage.instance;
  List<String> _arrImageUrls = [];
  int uploadItem = 0;
  bool _isUploading = false;

  TextEditingController _nickNameController = TextEditingController();
  var isSelected1 = false;
  var isSelected2 = false;
  var isSelected3 = false;
  var isSelected4 = false;
  var isSelected5 = false;
  var isSelected6 = false;
  var isSelected7 = false;
  var isSelected8 = false;
  var isSelected9 = false;
  Color color1 = Colors.blue;
  Color color2 = Colors.blue;
  Color color3 = Colors.blue;
  Color color4 = Colors.blue;
  Color color5 = Colors.blue;
  Color color6 = Colors.blue;
  Color color7 = Colors.blue;
  Color color8 = Colors.blue;
  Color color9 = Colors.blue;

  String tempExpression = '';

  FocusNode focusNode = FocusNode();

  // 카메라/갤러리에서 사진 가져올 때 사용
  XFile? _imageFile;
  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // TextField 기본값 설정
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    Expression _expression = Provider.of<Expression>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '프로필 수정하기',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: FutureBuilder(
        future: _myProfileInfo.getMyProfileInfo(),
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
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.17,
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '내 닉네임 수정하기',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          (_myProfileInfo.nickName.toString() == '' || _myProfileInfo.nickName.toString() == 'null') ? '미등록' : _myProfileInfo.getNickName,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: const SizedBox(),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextButton(
                                        child: Text(
                                            '수정하기',
                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)
                                        ),
                                        style: TextButton.styleFrom(
                                            backgroundColor: const Color(0xffFE9BE6)
                                        ),
                                        onPressed: () async {
                                          _nickNameController = TextEditingController(text: _myProfileInfo.getNickName);
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Icon(
                                                                FontAwesomeIcons.edit,
                                                                color: const Color(0xffFE9BE6),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Padding(
                                                                padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.005, 0, 0),
                                                                child: Text(
                                                                  '닉네임 변경',
                                                                  style: Theme.of(context).textTheme.bodyText1,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        content: TextField(
                                                          decoration: InputDecoration(
                                                            // border: InputBorder.none,
                                                          ),
                                                          controller: _nickNameController,
                                                          style: Theme.of(context).textTheme.bodyText2,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text(
                                                              '확인',
                                                              style: Theme.of(context).textTheme.bodyText2,
                                                            ),
                                                            onPressed: () {
                                                              _myProfileInfo.updateNickName(_nickNameController.text.toString());
                                                              _myProfileInfo.setNickName = _nickNameController.text.toString();
                                                              // Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                                                              _setState();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                              '취소',
                                                              style: Theme.of(context).textTheme.bodyText2,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    }
                                                );
                                              }
                                          );
                                        },
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.17,
                      child: Card(
                        elevation: 4.0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'D-Day 수정하기',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          _myProfileInfo.getCoupleRegDt == 'null' ? 'D-Day 미등록' : _myProfileInfo.getCoupleRegDt.toString().substring(0, 10),
                                          style: Theme.of(context).textTheme.bodyText2,
                                        )
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: const SizedBox(),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextButton(
                                        child: Text(
                                          _myProfileInfo.getCoupleRegDt == 'null' ? '날짜 선택' : '날짜 변경',
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                        ),
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: const Color(0xffFE9BE6)
                                        ),
                                        onPressed: () async {
                                          DateTime currentDate = DateTime.now();
                                          if (_myProfileInfo.getCoupleRegDt.toString() == "null") {
                                            currentDate = DateTime.now();
                                          } else {
                                            currentDate = DateTime.parse(_myProfileInfo.getCoupleRegDt.toString());
                                          }
                                          bool isCanceled = true;

                                          ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context, listen: false);

                                          Future<void> _selectDate(BuildContext context) async {
                                            final DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: currentDate,
                                              locale: Locale('ko'),
                                              helpText: "",
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2050),
                                              builder: (BuildContext context, Widget? child) {
                                                return Theme(
                                                  data: _themeProvider.themeData(_themeProvider.darkTheme).copyWith(
                                                    colorScheme: ColorScheme.light(
                                                      primary: Color(0xffFE9BE6),
                                                      onPrimary: Colors.white,
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
                                              await _myProfileInfo.updateCoupleRegDt(pickedDate);
                                            }
                                          }
                                          await _selectDate(context);
                                          if (isCanceled) {
                                            setState(() {
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Card(
                        elevation: 4.0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '내 프로필 사진 수정하기',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                                child: Center(
                                  child: imageProfile(_myProfileInfo.myProfileImgAddr.toString(), 'myProfileImgAddr', context),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    mainBannerImage(_myProfileInfo.mainBannerImgAddr.toString(), context),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Card(
                        elevation: 4.0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '내 기분 수정하기',
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
                                  ),
                                ),
                              ),
                              FutureBuilder(
                                  future: _fetchData(context),
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
                                    } else {
                                      return Container(
                                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '내 감정표현',
                                                          style: Theme.of(context).textTheme.bodyText2,
                                                        ),
                                                        myExpression,
                                                        Text(
                                                          _expression.myExpressionText.toString(),
                                                          style: Theme.of(context).textTheme.bodyText2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: const SizedBox()
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: TextButton(
                                                  child: Text(
                                                    '변경하기',
                                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    await showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return StatefulBuilder(
                                                            builder: (BuildContext context, StateSetter setState) {
                                                              return Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(4)
                                                                ),
                                                                child: Container(
                                                                  height: 400,
                                                                  child: Column(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            color: Color(0xffFE9BE6),
                                                                            // color: Color(0xffFF689F),
                                                                            child: SizedBox.expand(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Center(
                                                                                      child: Text(
                                                                                        '내 감정 변경하기',
                                                                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child: Container(
                                                                          color: Colors.white70,
                                                                          child: SizedBox.expand(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(15.0),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                          children: [
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.grinHearts,
                                                                                                    color: color1 = isSelected1 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected1 = !isSelected1;
                                                                                                      tempExpression = 'grinHearts';
                                                                                                      _changeColorByClick(1);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '사랑해',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color1 = isSelected1 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.grinSquint,
                                                                                                    color: color2 = isSelected2 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected2 = !isSelected2;
                                                                                                      tempExpression = 'grinSquint';
                                                                                                      _changeColorByClick(2);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '베리굿',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color2 = isSelected2 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.kissWinkHeart,
                                                                                                    color: color3 = isSelected3 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected3 = !isSelected3;
                                                                                                      tempExpression = 'kissWinkHeart';
                                                                                                      _changeColorByClick(3);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '라면먹고 갈래?',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color3 = isSelected3 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                          children: [
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.dizzy,
                                                                                                    color: color4 = isSelected4 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected4 = !isSelected4;
                                                                                                      tempExpression = 'dizzy';
                                                                                                      _changeColorByClick(4);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '아파요',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color4 = isSelected4 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.frown,
                                                                                                    color: color5 = isSelected5 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected5 = !isSelected5;
                                                                                                      tempExpression = 'frown';
                                                                                                      _changeColorByClick(5);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '짜증나',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color5 = isSelected5 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.grinBeamSweat,
                                                                                                    color: color6 = isSelected6 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected6 = !isSelected6;
                                                                                                      tempExpression = 'grinBeamSweat';
                                                                                                      _changeColorByClick(6);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '정말 난감해요;',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color6 = isSelected6 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                          children: [
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.smileBeam,
                                                                                                    color: color7 = isSelected7 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected7 = !isSelected7;
                                                                                                      tempExpression = 'smileBeam';
                                                                                                      _changeColorByClick(7);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '좋아요',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color7 = isSelected7 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.flushed,
                                                                                                    color: color8 = isSelected8 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected8 = !isSelected8;
                                                                                                      tempExpression = 'flushed';
                                                                                                      _changeColorByClick(8);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '멍',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color8 = isSelected8 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            Column(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FontAwesomeIcons.handshake,
                                                                                                    color: color9 = isSelected9 ? const Color(0xffFE9BE6) : Colors.grey,
                                                                                                    size: 30,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      isSelected9 = !isSelected9;
                                                                                                      tempExpression = 'handshake';
                                                                                                      _changeColorByClick(9);
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                                Text(
                                                                                                  '우리 화해할래?',
                                                                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: color9 = isSelected9 ? const Color(0xffFE9BE6) : Colors.grey,),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    onTap: () {

                                                                                    },
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Align(
                                                                                      alignment: Alignment.bottomRight,
                                                                                      child: Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        children: [
                                                                                          TextButton(
                                                                                            child: Text(
                                                                                              'OK',
                                                                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Color(0xffFE9BE6)),
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              await _expression.setExpression(tempExpression);
                                                                                              setState(() {
                                                                                                isSelected1 = false;
                                                                                                isSelected2 = false;
                                                                                                isSelected3 = false;
                                                                                                isSelected4 = false;
                                                                                                isSelected5 = false;
                                                                                                isSelected6 = false;
                                                                                                isSelected7 = false;
                                                                                                isSelected8 = false;
                                                                                                isSelected9 = false;
                                                                                                tempExpression = '';

                                                                                                myExpression = _expression.myExpressionWidget as Widget;
                                                                                                myExpressionText = _expression.myExpressionText.toString();
                                                                                                _myProfileInfo.setMyExpressionWidget = myExpression;
                                                                                                _myProfileInfo.setMyExpressionText = myExpressionText;
                                                                                              });
                                                                                              Navigator.of(context).pop();
                                                                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                                                                                            },
                                                                                          ),
                                                                                          TextButton(
                                                                                            child: Text(
                                                                                              'Cancel',
                                                                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Color(0xffFE9BE6)),
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                isSelected1 = false;
                                                                                                isSelected2 = false;
                                                                                                isSelected3 = false;
                                                                                                isSelected4 = false;
                                                                                                isSelected5 = false;
                                                                                                isSelected6 = false;
                                                                                                isSelected7 = false;
                                                                                                isSelected8 = false;
                                                                                                isSelected9 = false;
                                                                                                tempExpression = '';
                                                                                              });
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                    );
                                                    setState(() {
                                                      // myExpression = _expression.myExpressionWidget!;
                                                      // myExpressionText = _expression.myExpressionText.toString();
                                                    });
                                                  },
                                                  style: TextButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      backgroundColor: const Color(0xffFE9BE6)
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      );
                                    }
                                  }
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
            }
          }
      ),
    );
  }

  _fetchData(BuildContext context) async {
    Expression _expression = Provider.of<Expression>(context, listen: false);

    await _expression.getExpression();

    myExpression = _expression.myExpressionWidget!;
    myExpressionText = _expression.myExpressionText!;
    coupleExpression = _expression.coupleExpressionWidget!;
    coupleExpressionText = _expression.coupleExpressionText!;

    return _expression.expressionList;
  }

  Widget mainBannerImage(String imgAddr, BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    if (imgAddr == "null" || imgAddr == "") {
      return Card(
        margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/daily_date.png")
                )
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 3, 0),
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet("mainBannerImgAddr", context)));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            )
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 3.0),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_myProfileInfo.getMainBannerImgUrl)
                )
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 3, 0),
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet("mainBannerImgAddr", context)));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            )
        ),
      );
    }
  }

  Widget imageProfile(String imgAddr, String imgOf, BuildContext context) {
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    if (imgAddr == "null" || imgAddr == "") {
      return Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.18,
              backgroundImage: const AssetImage('images/basic_profile_img.jpg'),
            ),
            (imgOf == 'coupleProfileImgAddr') ?
            Padding(
              padding: EdgeInsets.all(0),
            ) :
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet(imgOf, context)));
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.18,
              backgroundImage: NetworkImage(
                _myProfileInfo.getMyProfileImgUrl
              ),
            ),
            (imgOf == 'coupleProfileImgAddr') ?
            Padding(
              padding: EdgeInsets.all(0),
            ) :
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  showCupertinoModalPopup(context: context, builder: ((builder) => iOSBottomSheet(imgOf, context)));
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget iOSBottomSheet(String imgOf, BuildContext context) {
    final provider = getIt.get<TempSignal>();
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);

    String uploadPath = imgOf == "mainBannerImgAddr" ? "main_banner" : "profile";
    return CupertinoActionSheet(
      actions: [
        Container(
          color: Colors.white,
          child: CupertinoActionSheetAction(
            child: Text(
              imgOf == "mainBannerImgAddr" ? "메인 배너 이미지 선택" : "프로필 이미지 선택",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13),
            ),
            onPressed: () {},
          ),
        ),
        Container(
          color: Colors.white,
          child: CupertinoActionSheetAction(
            child: Text(
              "앨범에서 선택",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),
            ),
            onPressed: () async {
              /// Navigator.pop(context)으로 기존 선택창을 닫고 앨범으로 이동
              Navigator.pop(context);

              final results = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.media,
                // allowedExtensions: ['png', 'jpg'],
              );

              if (results == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '선택된 파일이 없어요!',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  )
                );
                return null;
              }

              final path = results.files.single.path!;
              final fileName = results.files.single.name;

              bool result = await storage.uploadFile(path, fileName, uploadPath);

              List<String> deleteFile = [];

              if (result && imgOf == "mainBannerImgAddr" && (_myProfileInfo.mainBannerImgAddr.toString() != "null" || _myProfileInfo.mainBannerImgAddr.toString() != "")) {
                /// 업데이트 해주기 전에 그 전 사진은 삭제해야함
                /// 단, 프로필과 배경이미지가 같은 사진이라면 지우면 안됨
                if (_myProfileInfo.mainBannerImgAddr.toString() == _myProfileInfo.myProfileImgAddr.toString()) {
                  await _myProfileInfo.updateMainBannerImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                } else {
                  deleteFile.add(_myProfileInfo.mainBannerImgAddr.toString());
                  await storage.deleteFile(deleteFile, "main_banner");
                  await _myProfileInfo.updateMainBannerImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                }
              } else if (result && imgOf == "mainBannerImgAddr" && _myProfileInfo.mainBannerImgAddr.toString() == "null" || _myProfileInfo.mainBannerImgAddr.toString() == "") {
                await _myProfileInfo.updateMainBannerImgAddr(fileName);
                // _setState();
                provider.setIsIntentional = true;
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
              } else if (result && imgOf == "myProfileImgAddr" && (_myProfileInfo.myProfileImgAddr.toString() != "null" || _myProfileInfo.myProfileImgAddr.toString() != "")) {
                if (_myProfileInfo.mainBannerImgAddr.toString() == _myProfileInfo.myProfileImgAddr.toString()) {
                  await _myProfileInfo.updateProfileImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                } else {
                  deleteFile.add(_myProfileInfo.myProfileImgAddr.toString());
                  await storage.deleteFile(deleteFile, "profile");
                  await _myProfileInfo.updateProfileImgAddr(fileName);
                  // _setState();
                  provider.setIsIntentional = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                }
              } else if (result && imgOf == "myProfileImgAddr" && (_myProfileInfo.myProfileImgAddr.toString() == "null" || _myProfileInfo.myProfileImgAddr.toString() == "")) {
                await _myProfileInfo.updateProfileImgAddr(fileName);
                // _setState();
                provider.setIsIntentional = true;
                Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
              } else {
                globalAlert.globErrorAlert(context);
              }

              setState(() {

              });
            },
            isDefaultAction: true,
          ),
        ),
        Container(
          color: Colors.white,
          child: CupertinoActionSheetAction(
            child: Text(
              "기본 이미지 선택",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),
            ),
            onPressed: () async {
              /// 기본 이미지 선택하면 null 로 바꿔줘야함
              List<String> deleteFile = [];

              if (imgOf == "mainBannerImgAddr") {
                if (_myProfileInfo.mainBannerImgAddr.toString() != _myProfileInfo.myProfileImgAddr.toString()) {
                  deleteFile.add(_myProfileInfo.mainBannerImgAddr.toString());
                  await storage.deleteFile(deleteFile, "main_banner");
                  _myProfileInfo.updateMainBannerImgAddr("null");
                  _myProfileInfo.setMainBannerImgAddr = "null";
                }
              } else {
                if (_myProfileInfo.mainBannerImgAddr.toString() != _myProfileInfo.myProfileImgAddr.toString()) {
                  deleteFile.add(_myProfileInfo.myProfileImgAddr.toString());
                  await storage.deleteFile(deleteFile, "profile");
                  _myProfileInfo.updateProfileImgAddr("null");
                  _myProfileInfo.setMyProfileImgAddr = "null";
                }
              }
              setState(() {
                Navigator.pop(context);
              });
            },
            isDefaultAction: true,
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "Cancel",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.blue),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _changeColorByClick(int index) {
    switch (index) {
      case 1:
        isSelected2 = false;
        isSelected3 = false;
        isSelected4 = false;
        isSelected5 = false;
        isSelected6 = false;
        isSelected7 = false;
        isSelected8 = false;
        isSelected9 = false;
        break;
      case 2:
        isSelected1 = false;
        isSelected3 = false;
        isSelected4 = false;
        isSelected5 = false;
        isSelected6 = false;
        isSelected7 = false;
        isSelected8 = false;
        isSelected9 = false;
        break;
      case 3:
        isSelected1 = false;
        isSelected2 = false;
        isSelected4 = false;
        isSelected5 = false;
        isSelected6 = false;
        isSelected7 = false;
        isSelected8 = false;
        isSelected9 = false;
        break;
      case 4:
        isSelected1 = false;
        isSelected2 = false;
        isSelected3 = false;
        isSelected5 = false;
        isSelected6 = false;
        isSelected7 = false;
        isSelected8 = false;
        isSelected9 = false;
        break;
      case 5:
        isSelected1 = false;
        isSelected2 = false;
        isSelected3 = false;
        isSelected4 = false;
        isSelected6 = false;
        isSelected7 = false;
        isSelected8 = false;
        isSelected9 = false;
        break;
      case 6:
        isSelected1 = false;
        isSelected2 = false;
        isSelected3 = false;
        isSelected4 = false;
        isSelected5 = false;
        isSelected7 = false;
        isSelected8 = false;
        isSelected9 = false;
        break;
      case 7:
        isSelected1 = false;
        isSelected2 = false;
        isSelected3 = false;
        isSelected4 = false;
        isSelected5 = false;
        isSelected6 = false;
        isSelected8 = false;
        isSelected9 = false;
        break;
      case 8:
        isSelected1 = false;
        isSelected2 = false;
        isSelected3 = false;
        isSelected4 = false;
        isSelected5 = false;
        isSelected6 = false;
        isSelected7 = false;
        isSelected9 = false;
        break;
      case 9:
        isSelected1 = false;
        isSelected2 = false;
        isSelected3 = false;
        isSelected4 = false;
        isSelected5 = false;
        isSelected6 = false;
        isSelected7 = false;
        isSelected8 = false;
        break;
    }
  }
  _setState() {
    setState(() {});
  }
}
