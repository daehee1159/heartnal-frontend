class TodaySignalDto {
  int? todaySignalSeq;
  int? senderMemberSeq;
  int? recipientMemberSeq;
  String? coupleCode;
  String? questions;
  String? senderAnswers;
  String? recipientAnswers;
  bool? senderComplete;
  bool? recipientComplete;
  int? finalScore;
  String? regDt;

  TodaySignalDto(
      {this.todaySignalSeq,
        this.senderMemberSeq,
        this.recipientMemberSeq,
        this.coupleCode,
        this.questions,
        this.senderAnswers,
        this.recipientAnswers,
        this.senderComplete,
        this.recipientComplete,
        this.finalScore,
        this.regDt});

  TodaySignalDto.fromJson(Map<String, dynamic> json) {
    todaySignalSeq = json['todaySignalSeq'];
    senderMemberSeq = json['senderMemberSeq'];
    recipientMemberSeq = json['recipientMemberSeq'];
    coupleCode = json['coupleCode'];
    questions = json['questions'];
    senderAnswers = json['senderAnswers'];
    recipientAnswers = json['recipientAnswers'];
    senderComplete = json['senderComplete'];
    recipientComplete = json['recipientComplete'];
    finalScore = json['finalScore'];
    regDt = json['regDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todaySignalSeq'] = this.todaySignalSeq;
    data['senderMemberSeq'] = this.senderMemberSeq;
    data['recipientMemberSeq'] = this.recipientMemberSeq;
    data['coupleCode'] = this.coupleCode;
    data['questions'] = this.questions;
    data['senderAnswers'] = this.senderAnswers;
    data['recipientAnswers'] = this.recipientAnswers;
    data['senderComplete'] = this.senderComplete;
    data['recipientComplete'] = this.recipientComplete;
    data['finalScore'] = this.finalScore;
    data['regDt'] = this.regDt;
    return data;
  }
}
