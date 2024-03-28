class MenstrualCycleDto {
  int? menstrualCycleSeq;
  int? memberSeq;
  int? coupleMemberSeq;
  String? coupleCode;

  String? lastMenstrualStartDt;
  int? menstrualCycle;
  int? menstrualPeriod;
  String? contraceptiveYN;
  String? takingContraceptiveDt;
  String? contraceptive;
  String? myAlarmYN;
  String? myAlarmDefaultMessageYN;
  String? coupleAlarmYN;
  String? coupleAlarmDefaultMessageYN;
  String? regDt;

  MenstrualCycleDto(
      {this.menstrualCycleSeq,
        this.memberSeq,
        this.coupleMemberSeq,
        this.coupleCode,
        this.lastMenstrualStartDt,
        this.menstrualCycle,
        this.menstrualPeriod,
        this.contraceptiveYN,
        this.takingContraceptiveDt,
        this.contraceptive,
        this.myAlarmYN,
        this.myAlarmDefaultMessageYN,
        this.coupleAlarmYN,
        this.coupleAlarmDefaultMessageYN,
        this.regDt});

  MenstrualCycleDto.fromJson(Map<String, dynamic> json) {
    menstrualCycleSeq = json['menstrualCycleSeq'];
    memberSeq = json['memberSeq'];
    coupleMemberSeq = json['coupleMemberSeq'];
    coupleCode = json['coupleCode'];
    lastMenstrualStartDt = json['lastMenstrualStartDt'];
    menstrualCycle = json['menstrualCycle'];
    menstrualPeriod = json['menstrualPeriod'];
    contraceptiveYN = json['contraceptiveYN'];
    takingContraceptiveDt = json['takingContraceptiveDt'];
    contraceptive = json['contraceptive'];
    myAlarmYN = json['myAlarmYN'];
    myAlarmDefaultMessageYN = json['myAlarmDefaultMessageYN'];
    coupleAlarmYN = json['coupleAlarmYN'];
    coupleAlarmDefaultMessageYN = json['coupleAlarmDefaultMessageYN'];
    regDt = json['regDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menstrualCycleSeq'] = this.menstrualCycleSeq;
    data['memberSeq'] = this.memberSeq;
    data['coupleMemberSeq'] = this.coupleMemberSeq;
    data['coupleCode'] = this.coupleCode;
    data['lastMenstrualStartDt'] = this.lastMenstrualStartDt;
    data['menstrualCycle'] = this.menstrualCycle;
    data['menstrualPeriod'] = this.menstrualPeriod;
    data['contraceptiveYN'] = this.contraceptiveYN;
    data['takingContraceptiveDt'] = this.takingContraceptiveDt;
    data['contraceptive'] = this.contraceptive;
    data['myAlarmYN'] = this.myAlarmYN;
    data['myAlarmDefaultMessageYN'] = this.myAlarmDefaultMessageYN;
    data['coupleAlarmYN'] = this.coupleAlarmYN;
    data['coupleAlarmDefaultMessageYN'] = this.coupleAlarmDefaultMessageYN;
    data['regDt'] = this.regDt;
    return data;
  }
}
