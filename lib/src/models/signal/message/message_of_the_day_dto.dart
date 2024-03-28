class MessageOfTheDayDto {
  int? messageOfTheDaySeq;
  int? senderMemberSeq;
  int? recipientMemberSeq;
  String? coupleCode;
  String? message;
  String? regDt;

  MessageOfTheDayDto(
      {this.messageOfTheDaySeq,
        this.senderMemberSeq,
        this.recipientMemberSeq,
        this.coupleCode,
        this.message,
        this.regDt});

  MessageOfTheDayDto.fromJson(Map<String, dynamic> json) {
    messageOfTheDaySeq = json['messageOfTheDaySeq'];
    senderMemberSeq = json['senderMemberSeq'];
    recipientMemberSeq = json['recipientMemberSeq'];
    coupleCode = json['coupleCode'];
    message = json['message'];
    regDt = json['regDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageOfTheDaySeq'] = this.messageOfTheDaySeq;
    data['senderMemberSeq'] = this.senderMemberSeq;
    data['recipientMemberSeq'] = this.recipientMemberSeq;
    data['coupleCode'] = this.coupleCode;
    data['message'] = this.message;
    data['regDt'] = this.regDt;
    return data;
  }
}
