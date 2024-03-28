import 'dart:io';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:couple_signal/src/models/couple_diary/couple_diary.dart';
import 'package:couple_signal/src/models/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:couple_signal/src/service/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

String datetime = "";

class UpdateCoupleDiary extends StatefulWidget {
  final int diarySeq;
  final String datetime;
  final String contents;
  final List<String> imgList;
  final List<String> imgNameList;

  const UpdateCoupleDiary({Key? key, required this.diarySeq, required this.datetime, required this.contents, required this.imgList, required this.imgNameList}) : super(key: key);

  @override
  _UpdateCoupleDiaryState createState() => _UpdateCoupleDiaryState();
}

class _UpdateCoupleDiaryState extends State<UpdateCoupleDiary> {
  TextEditingController _textEditingController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];
  firebase_storage.FirebaseStorage _storageRef = firebase_storage.FirebaseStorage.instance;
  List<String> _arrImageUrls = [];
  List<String> _arrFileNames = [];
  int uploadItem = 0;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    datetime = widget.datetime;
    _textEditingController = TextEditingController(text: widget.contents);
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    CoupleDiary _coupleDiaryProvider = Provider.of<CoupleDiary>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "커플 다이어리 수정",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: [
          TextButton(
            child: Text(
              "수정",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onPressed: () async {
              List<String> pastImgList = [];
              switch (_coupleDiaryProvider.getFileCount) {
                case 1:
                  pastImgList.add(_coupleDiaryProvider.getFileName1.toString());
                  break;
                case 2:
                  pastImgList.add(_coupleDiaryProvider.getFileName1.toString());
                  pastImgList.add(_coupleDiaryProvider.getFileName2.toString());
                  break;
                case 3:
                  pastImgList.add(_coupleDiaryProvider.getFileName1.toString());
                  pastImgList.add(_coupleDiaryProvider.getFileName2.toString());
                  pastImgList.add(_coupleDiaryProvider.getFileName3.toString());
                  break;
              }

              bool deleteResult = false;

              if (_selectedFiles.length == 0) {
                _arrFileNames.addAll(widget.imgNameList);
              } else {
                for (int i = 0; i < _selectedFiles.length; i++) {
                  _arrFileNames.add(_selectedFiles[i].name);
                }
                deleteResult = await storage.deleteFile(pastImgList, "couple_diary");
                if (!deleteResult) {
                  return GlobalAlert().globErrorAlert(context);
                }
              }

              bool result = await _coupleDiaryProvider.updateCoupleDiary(widget.diarySeq, _arrFileNames, _textEditingController.text, datetime);
              if (result) {
                return updateSuccessAlert(context);
              } else {
                return GlobalAlert().globErrorAlert(context);
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: _isUploading ? showLoading() :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "데이트 날짜 변경하기",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 10,),
                Card(
                  color: Colors.white,
                  elevation: 0.0,
                  margin: const EdgeInsets.all(0.0),
                  child: Padding(
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
                                  // await _myProfileInfo.updateCoupleRegDt(pickedDate);
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
                ),
                SizedBox(height: 20,),
                Text(
                  "사진 변경하기",
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
                _selectedFiles.length == 0
                    ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              "기존 이미지",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              itemCount: widget.imgList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.network(
                                    widget.imgList[index],
                                    fit: BoxFit.fitWidth,
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      )
                  ),
                )
                    : Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: GridView.builder(
                    itemCount: _selectedFiles.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.file(
                          File(_selectedFiles[index].path),
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '내용 수정하기',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
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
                        decoration: InputDecoration(
                            border: InputBorder.none
                        ),
                        controller: _textEditingController,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
              ],
            ),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
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

  void uploadFunction(List<XFile> _images) {
    setState(() {
      _isUploading = true;
    });
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = uploadFile(_images[i]);
      if (imageUrl.toString() == "false") {
        /// alert 띄우고 빠져나가기
        break;
      } else {
        _arrImageUrls.add(imageUrl.toString());
      }
    }
  }

  Future<String> uploadFile(XFile _image) async {
    try {
      firebase_storage.Reference reference = _storageRef.ref().child("multiple_images").child(_image.name);
      firebase_storage.UploadTask uploadTask = reference.putFile(File(_image.path));
      await uploadTask.whenComplete(() {
        setState(() {
          uploadItem++;
          if (uploadItem == _selectedFiles.length) {
            _isUploading = false;
            uploadItem = 0;
          }
        });
      });
      return await reference.getDownloadURL();
    } catch(e) {
      print(e);
      return "false";
    }
  }

  Future<bool> deleteFile() async {
    List<String> pastImageList = widget.imgList;
    try {
      for (int i = 0; i < pastImageList.length; i++) {
        firebase_storage.Reference reference = _storageRef.ref().child("multiple_images").child(pastImageList[i]);
        await reference.delete();
      }
      return true;
    } catch(e) {
      print(e);
      return false;
    }
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

  updateSuccessAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "수정 성공",
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
        '수정에 성공했어요.',
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
            Navigator.of(context).pop();
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
