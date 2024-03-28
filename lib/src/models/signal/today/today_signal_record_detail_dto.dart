class TodaySignalRecordDetailDto {
  int? todaySignalSeq;
  int? todaySignalQuestionSeq;
  String? question;
  String? senderAnswer;
  String? recipientAnswer;
  bool? isCorrect;

  TodaySignalRecordDetailDto(
      {this.todaySignalSeq,
        this.todaySignalQuestionSeq,
        this.question,
        this.senderAnswer,
        this.recipientAnswer,
        this.isCorrect});

  TodaySignalRecordDetailDto.fromJson(Map<String, dynamic> json) {
    todaySignalSeq = json['todaySignalSeq'];
    todaySignalQuestionSeq = json['todaySignalQuestionSeq'];
    question = json['question'];
    senderAnswer = json['senderAnswer'];
    recipientAnswer = json['recipientAnswer'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todaySignalSeq'] = this.todaySignalSeq;
    data['todaySignalQuestionSeq'] = this.todaySignalQuestionSeq;
    data['question'] = this.question;
    data['senderAnswer'] = this.senderAnswer;
    data['recipientAnswer'] = this.recipientAnswer;
    data['isCorrect'] = this.isCorrect;
    return data;
  }
}
