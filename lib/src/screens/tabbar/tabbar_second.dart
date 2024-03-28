import 'dart:convert';

import 'package:couple_signal/src/models/couple_diary/couple_diary.dart';
import 'package:couple_signal/src/screens/diary/couple_diary_detail.dart';
import 'package:couple_signal/src/screens/diary/create_couple_diary.dart';
import 'package:couple_signal/src/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabBarSecond extends StatefulWidget {
  const TabBarSecond({Key? key}) : super(key: key);

  @override
  _TabBarSecondState createState() => _TabBarSecondState();
}

class _TabBarSecondState extends State<TabBarSecond> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CoupleDiary _coupleDiaryProvider = Provider.of<CoupleDiary>(context, listen: false);
    CoupleDiary coupleDiary = new CoupleDiary();
    final Storage storage = Storage();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffFE9BE6),
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCoupleDiary()));
        },
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: coupleDiary.getCoupleDiary(),
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
            } else if (snapshot.connectionState == ConnectionState.done && (snapshot.data == null || snapshot.data.isEmpty)) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        '등록된 다이어리가 없어요.\n다이어리를 등록해주세요!',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black),
                      ),
                    )
                  ],
                ),
              );
            } else {
            List<CoupleDiary> fetchData = snapshot.data;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '우리 둘만의 다이어리',
                      style: Theme.of(context).textTheme.bodyText2
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 8,
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GridView.builder(
                      itemCount: fetchData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 1.0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black
                                )
                              ),
                              margin: new EdgeInsets.all(0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder(
                                    future: storage.downloadURL(fetchData[index].fileName1.toString(), "couple_diary"),
                                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                        return AspectRatio(
                                          aspectRatio: 18.0 / 18.0,
                                          child: Image.network(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      return Center(child: Container());
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            _coupleDiaryProvider.setDiarySeq = fetchData[index].diarySeq;
                            _coupleDiaryProvider.setWriterMemberSeq = fetchData[index].writerMemberSeq;
                            _coupleDiaryProvider.setCoupleCode = fetchData[index].coupleCode;

                            _coupleDiaryProvider.setContents = fetchData[index].contents;
                            _coupleDiaryProvider.setDatetime = fetchData[index].datetime;
                            _coupleDiaryProvider.setFileName1 = fetchData[index].fileName1;
                            _coupleDiaryProvider.setFileName2 = fetchData[index].fileName2;
                            _coupleDiaryProvider.setFileName3 = fetchData[index].fileName3;

                            if (_coupleDiaryProvider.fileName2 != null && _coupleDiaryProvider.fileName3 == null) {
                              _coupleDiaryProvider.setFileCount = 2;
                            } else if (_coupleDiaryProvider.fileName2 != null && _coupleDiaryProvider.fileName3 != null) {
                              _coupleDiaryProvider.setFileCount = 3;
                            } else {
                              _coupleDiaryProvider.setFileCount = 1;
                            }

                            _coupleDiaryProvider.setLikeYN = fetchData[index].likeYN;
                            _coupleDiaryProvider.setLikeMember1 = fetchData[index].likeMember1;
                            _coupleDiaryProvider.setLikeMember2 = fetchData[index].likeMember2;
                            _coupleDiaryProvider.setLikeCount = fetchData[index].likeCount;
                            _coupleDiaryProvider.setRegDt = fetchData[index].regDt;

                            int diarySeq = _coupleDiaryProvider.diarySeq!;
                            int writerMemberSeq = _coupleDiaryProvider.writerMemberSeq!;
                            List<String> imgList = await _coupleDiaryProvider.fileUrlToList();
                            String contents = _coupleDiaryProvider.getContents.toString();
                            String datetime = _coupleDiaryProvider.getDatetime.toString();

                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CoupleDiaryDetailPage(
                                        diarySeq: diarySeq,
                                        writerMemberSeq: writerMemberSeq,
                                        imgList: imgList,
                                        contents: contents,
                                        datetime: datetime,
                                      )
                                )
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      )
    );
  }
}
