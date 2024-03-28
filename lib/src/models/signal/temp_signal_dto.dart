class TempSignalDto {
  int? tempSignalSeq;
  String? category;
  int? signalSeq;
  String? position;
  int? memberSeq;
  int? tryCount;
  bool? termination;

  TempSignalDto(
      {this.tempSignalSeq,
        this.category,
        this.signalSeq,
        this.position,
        this.memberSeq,
        this.tryCount,
        this.termination});

  TempSignalDto.fromJson(Map<String, dynamic> json) {
    tempSignalSeq = json['tempSignalSeq'];
    category = json['category'];
    signalSeq = json['signalSeq'];
    position = json['position'];
    memberSeq = json['memberSeq'];
    tryCount = json['tryCount'];
    termination = json['termination'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tempSignalSeq'] = this.tempSignalSeq;
    data['category'] = this.category;
    data['signalSeq'] = this.signalSeq;
    data['position'] = this.position;
    data['memberSeq'] = this.memberSeq;
    data['tryCount'] = this.tryCount;
    data['termination'] = this.termination;
    return data;
  }
}
