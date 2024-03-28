import 'dart:io';

import 'package:couple_signal/src/models/couple_diary/couple_diary.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/theme/theme_provider.dart';
import 'package:couple_signal/src/screens/tabbar/tabbar_second.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:couple_signal/src/service/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

String datetime = "";
final _formKey = GlobalKey<FormState>();

class CreateCoupleDiary extends StatefulWidget {
  const CreateCoupleDiary({Key? key}) : super(key: key);

  @override
  _CreateCoupleDiaryState createState() => _CreateCoupleDiaryState();
}

class _CreateCoupleDiaryState extends State<CreateCoupleDiary> {
  final Storage storage = Storage();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];
  firebase_storage.FirebaseStorage _storageRef = firebase_storage.FirebaseStorage.instance;
  List<String> _arrImageUrls = [];
  List<String> _arrFileNames = [];
  int uploadItem = 0;
  bool _isUploading = false;

  TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    _textController = new TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    CoupleDiary _coupleDiaryProvider = Provider.of<CoupleDiary>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'images/heartnal_bi.png',
          height: MediaQuery.of(context).size.height * 0.04,
          fit: BoxFit.contain,
        ),
        actions: [
          TextButton(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.007, 0, 0),
              child: Text(
                "저장",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            onPressed: () async {
              if (_selectedFiles.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이미지를 선택해주세요.",style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),textAlign: TextAlign.center,)));
              } else if (_textController.text == "") {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("다이어리 내용을 입력해주세요.",style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),textAlign: TextAlign.center,)));
              } else if (datetime == "") {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("데이트 날짜를 선택해주세요.",style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),textAlign: TextAlign.center,)));
              } else {
                for (int i = 0; i < _selectedFiles.length; i++) {
                  _arrFileNames.add(_selectedFiles[i].name);
                }
                try {
                  await uploadFunction(_selectedFiles, context);
                  bool result = await _coupleDiaryProvider.setCoupleDiary(_arrFileNames, _textController.text, datetime);
                  if (result) {
                    // await GlobalAlert().globSaveSuccessAlert(context);
                    // setState(() {
                    //   Navigator.of(context).pop();
                    // });
                  } else {
                    GlobalAlert().globErrorAlert(context);
                  }
                } catch(e) {
                  GlobalAlert().globErrorAlert(context);
                }
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, bottom),
            child: Container(
              child: _isUploading
                  ? Center(child: showLoading())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Card(
                            elevation: 4.0,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "데이트 정보 입력하기",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            datetime == "" ? "날짜 미선택" : datetime,
                                            style: datetime == "" ? Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey) : Theme.of(context).textTheme.bodyText2,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: const SizedBox(),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextButton.icon(
                                            onPressed: () async {
                                              DateTime currentDate = DateTime.now();
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
                                                  datetime = pickedDate.toString().substring(0, 10);
                                                }
                                              }
                                              await _selectDate(context);
                                              if (isCanceled) {
                                                setState(() {

                                                });
                                              }
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.calendarAlt,
                                              color: Colors.white,
                                              size: 23,
                                            ),
                                            label: Padding(
                                              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.005, 0, 0),
                                              child: Text(
                                                "날짜 선택",
                                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                                backgroundColor: const Color(0xffFE9BE6)
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.38,
                          child: Card(
                            elevation: 4.0,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "사진 선택하기",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              selectImages(context);
                                            },
                                            icon: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              "사진 선택",
                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                            ),
                                            style: TextButton.styleFrom(
                                                backgroundColor: const Color(0xffFE9BE6)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  _selectedFiles.length == 0
                                      ? Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                        height: MediaQuery.of(context).size.height * 0.25,
                                        child: Center(
                                          child: Text(
                                            "선택된 이미지가 없어요.",
                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                          ))),
                                  )
                                      : Container(
                                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    child: GridView.builder(
                                      itemCount: _selectedFiles.length,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,),
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0.0),
                                          child: Image.file(
                                            File(_selectedFiles[index].path),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.38,
                          child: Card(
                            elevation: 4.0,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    child: Text(
                                      '내용 입력하기',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.28,
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
                                          textInputAction: TextInputAction.newline,
                                          controller: _textController,
                                          style: Theme.of(context).textTheme.bodyText2,
                                          decoration: InputDecoration.collapsed(
                                            hintText: '내용을 입력해주세요!',
                                            hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                          ),
                                          // maxLines: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),
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

  Widget showLoading() {
    return Center(
      child: Column(
        children: [
          Text("Uploading : " + uploadItem.toString() + "/" + _selectedFiles.length.toString()),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  uploadFunction(List<XFile> _images, BuildContext context) {
    setState(() {
      _isUploading = true;
    });
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = uploadFile(_images[i], context);
      if (imageUrl.toString() == "false") {
        /// alert 띄우고 빠져나가기
        break;
      } else {
        _arrImageUrls.add(imageUrl.toString());
      }
    }
  }

  Future<String> uploadFile(XFile _image, BuildContext context) async {
    try {
      firebase_storage.Reference reference = _storageRef.ref().child("couple_diary").child(_image.name);
      firebase_storage.UploadTask uploadTask = reference.putFile(File(_image.path));
      await uploadTask.whenComplete(() {
        setState(() {
          uploadItem++;
          if (uploadItem == _selectedFiles.length) {
            _isUploading = false;
            uploadItem = 0;
            _arrFileNames.add(_image.name);
            GlobalAlert().globSaveSuccessAlert(context);
          }
        });
      });
      return await reference.getDownloadURL();
    } catch(e) {
      return "false";
    }
  }

  Future<void> selectImages(BuildContext context) async {
    if (_selectedFiles != null) {
      _selectedFiles.clear();
    }
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty && imgs.length <= 3) {
        _selectedFiles.addAll(imgs);
      } else if (imgs.length <= 4) {
        selectedImageError(context);
      }
    } catch (e) {
      print("Something Wrong" + e.toString());
    }

    setState(() {});
  }

  selectedImageError(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "오류 발생",
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
        '등록할 사진은 3개까지\n선택이 가능해요!',
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
