class MenstrualCycleMessageDto {
  int? menstrualCycleMessageSeq;
  int? memberSeq;
  int? coupleMemberSeq;
  String? coupleCode;

  String? menstruation3DaysAgoAlarm;
  String? menstruation3DaysAgo;
  String? menstruationDtAlarm;
  String? menstruationDt;
  String? ovulationDtAlarm;
  String? ovulationDt;
  String? fertileWindowStartDtAlarm;
  String? fertileWindowStartDt;
  String? fertileWindowsEndDtAlarm;
  String? fertileWindowsEndDt;

  MenstrualCycleMessageDto(
      {this.menstrualCycleMessageSeq,
        this.memberSeq,
        this.coupleMemberSeq,
        this.coupleCode,
        this.menstruation3DaysAgoAlarm,
        this.menstruation3DaysAgo,
        this.menstruationDtAlarm,
        this.menstruationDt,
        this.ovulationDtAlarm,
        this.ovulationDt,
        this.fertileWindowStartDtAlarm,
        this.fertileWindowStartDt,
        this.fertileWindowsEndDtAlarm,
        this.fertileWindowsEndDt});

  MenstrualCycleMessageDto.fromJson(Map<String, dynamic> json) {
    menstrualCycleMessageSeq = json['menstrualCycleMessageSeq'];
    memberSeq = json['memberSeq'];
    coupleMemberSeq = json['coupleMemberSeq'];
    coupleCode = json['coupleCode'];
    menstruation3DaysAgoAlarm = json['menstruation3DaysAgoAlarm'];
    menstruation3DaysAgo = json['menstruation3DaysAgo'];
    menstruationDtAlarm = json['menstruationDtAlarm'];
    menstruationDt = json['menstruationDt'];
    ovulationDtAlarm = json['ovulationDtAlarm'];
    ovulationDt = json['ovulationDt'];
    fertileWindowStartDtAlarm = json['fertileWindowStartDtAlarm'];
    fertileWindowStartDt = json['fertileWindowStartDt'];
    fertileWindowsEndDtAlarm = json['fertileWindowsEndDtAlarm'];
    fertileWindowsEndDt = json['fertileWindowsEndDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menstrualCycleMessageSeq'] = this.menstrualCycleMessageSeq;
    data['memberSeq'] = this.memberSeq;
    data['coupleMemberSeq'] = this.coupleMemberSeq;
    data['coupleCode'] = this.coupleCode;
    data['menstruation3DaysAgoAlarm'] = this.menstruation3DaysAgoAlarm;
    data['menstruation3DaysAgo'] = this.menstruation3DaysAgo;
    data['menstruationDtAlarm'] = this.menstruationDtAlarm;
    data['menstruationDt'] = this.menstruationDt;
    data['ovulationDtAlarm'] = this.ovulationDtAlarm;
    data['ovulationDt'] = this.ovulationDt;
    data['fertileWindowStartDtAlarm'] = this.fertileWindowStartDtAlarm;
    data['fertileWindowStartDt'] = this.fertileWindowStartDt;
    data['fertileWindowsEndDtAlarm'] = this.fertileWindowsEndDtAlarm;
    data['fertileWindowsEndDt'] = this.fertileWindowsEndDt;
    return data;
  }
}
