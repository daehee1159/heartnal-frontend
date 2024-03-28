class CalendarDto {
  int calendarSeq = 0;
  bool isPeriod = false;
  String? startDt;
  String? endDt;
  String? color;
  String? memo;
  // String? datetime;
  // List<MemoLists>? memoLists;

  CalendarDto({required this.calendarSeq, required this.isPeriod, this.startDt, this.endDt, this.color, this.memo});

  CalendarDto.fromJson(Map<String, dynamic> json) {
    calendarSeq = json['calendarSeq'];
    isPeriod = json['isPeriod'];
    startDt = json['startDt'];
    endDt = json['endDt'];
    color = json['color'];
    memo = json['memo'];
    // datetime = json['datetime'];
    // if (json['memoLists'] != null) {
    //   memoLists = <MemoLists>[];
    //   json['memoLists'].forEach((v) {
    //     memoLists!.add(new MemoLists.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calendarSeq'] = this.calendarSeq;
    data['isPeriod'] = this.isPeriod;
    data['startDt'] = this.startDt;
    data['endDt'] = this.endDt;
    data['color'] = this.color;
    data['memo'] = this.memo;
    // data['datetime'] = this.datetime;
    // if (this.memoLists != null) {
    //   data['memoLists'] = this.memoLists!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

// class MemoLists {
//   String? memo;
//
//   MemoLists({this.memo});
//
//   MemoLists.fromJson(Map<String, dynamic> json) {
//     memo = json['memo'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['memo'] = this.memo;
//     return data;
//   }
// }
