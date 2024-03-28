class CheckMyTurn {
  bool? isMyTurn;
  String? category;
  String? myPosition;
  int? tryCount;

  CheckMyTurn({this.isMyTurn, this.category, this.myPosition, this.tryCount});

  CheckMyTurn.fromJson(Map<String, dynamic> json) {
    isMyTurn = json['isMyTurn'];
    category = json['category'];
    myPosition = json['myPosition'];
    tryCount = json['tryCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isMyTurn'] = this.isMyTurn;
    data['category'] = this.category;
    data['myPosition'] = this.myPosition;
    data['tryCount'] = this.tryCount;
    return data;
  }
}
