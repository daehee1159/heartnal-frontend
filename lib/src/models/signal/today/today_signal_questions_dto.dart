class TodaySignalQuestionsDto {
  int? todaySignalQuestionSeq;
  String? question;
  String? answer1;
  String? answer2;
  String? answer3;
  String? answer4;
  String? answer5;
  String? answer6;
  List<String>? answerList;
  String? regDt;

  TodaySignalQuestionsDto(
      {this.todaySignalQuestionSeq,
        this.question,
        this.answer1,
        this.answer2,
        this.answer3,
        this.answer4,
        this.answer5,
        this.answer6,
        this.answerList,
        this.regDt});

  TodaySignalQuestionsDto.fromJson(Map<String, dynamic> json) {
    todaySignalQuestionSeq = json['todaySignalQuestionSeq'];
    question = json['question'];
    answer1 = json['answer1'];
    answer2 = json['answer2'];
    answer3 = json['answer3'];
    answer4 = json['answer4'];
    answer5 = json['answer5'];
    answer6 = json['answer6'];
    answerList = json['answerList'].cast<String>();
    regDt = json['regDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todaySignalQuestionSeq'] = this.todaySignalQuestionSeq;
    data['question'] = this.question;
    data['answer1'] = this.answer1;
    data['answer2'] = this.answer2;
    data['answer3'] = this.answer3;
    data['answer4'] = this.answer4;
    data['answer5'] = this.answer5;
    data['answer6'] = this.answer6;
    data['answerList'] = this.answerList;
    data['regDt'] = this.regDt;
    return data;
  }
}
