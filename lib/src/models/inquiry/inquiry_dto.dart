class InquiryDto {
  int? inquirySeq;
  int? memberSeq;
  String? inquiryTitle;
  String? inquiries;
  String? inquiryDt;
  String? answerContent;
  String? answerDt;

  InquiryDto(
      {this.inquirySeq,
        this.memberSeq,
        this.inquiryTitle,
        this.inquiries,
        this.inquiryDt,
        this.answerContent,
        this.answerDt});

  InquiryDto.fromJson(Map<String, dynamic> json) {
    inquirySeq = json['inquirySeq'];
    memberSeq = json['memberSeq'];
    inquiryTitle = json['inquiryTitle'];
    inquiries = json['inquiries'];
    inquiryDt = json['inquiryDt'];
    answerContent = json['answerContent'];
    answerDt = json['answerDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inquirySeq'] = this.inquirySeq;
    data['memberSeq'] = this.memberSeq;
    data['inquiryTitle'] = this.inquiryTitle;
    data['inquiries'] = this.inquiries;
    data['inquiryDt'] = this.inquiryDt;
    data['answerContent'] = this.answerContent;
    data['answerDt'] = this.answerDt;
    return data;
  }
}
