class MenstrualCycleCalendarDto {
  bool? isValid;
  String? beforeMenstrualCycleStartDt;
  String? beforeMenstrualCycleEndDt;
  String? beforeMenstrualCycleMemo;
  String? menstrualCycleStartDt;
  String? menstrualCycleEndDt;
  String? menstrualCycleMemo;
  String? afterMenstrualCycleStartDt;
  String? afterMenstrualCycleEndDt;
  String? afterMenstrualCycleMemo;
  String? ovulationDt;
  String? ovulationDtMemo;
  String? afterOvulationDt;
  String? afterOvulationDtMemo;
  String? fertileWindowStartDt;
  String? fertileWindowEndDt;
  String? fertileWindowMemo;
  String? afterFertileWindowStartDt;
  String? afterFertileWindowEndDt;
  String? afterFertileWindowMemo;

  MenstrualCycleCalendarDto(
      {this.isValid,
        this.beforeMenstrualCycleStartDt,
        this.beforeMenstrualCycleEndDt,
        this.beforeMenstrualCycleMemo,
        this.menstrualCycleStartDt,
        this.menstrualCycleEndDt,
        this.menstrualCycleMemo,
        this.afterMenstrualCycleStartDt,
        this.afterMenstrualCycleEndDt,
        this.afterMenstrualCycleMemo,
        this.ovulationDt,
        this.ovulationDtMemo,
        this.afterOvulationDt,
        this.afterOvulationDtMemo,
        this.fertileWindowStartDt,
        this.fertileWindowEndDt,
        this.fertileWindowMemo,
        this.afterFertileWindowStartDt,
        this.afterFertileWindowEndDt,
        this.afterFertileWindowMemo});

  MenstrualCycleCalendarDto.fromJson(Map<String, dynamic> json) {
    isValid = json['isValid'];
    beforeMenstrualCycleStartDt = json['beforeMenstrualCycleStartDt'];
    beforeMenstrualCycleEndDt = json['beforeMenstrualCycleEndDt'];
    beforeMenstrualCycleMemo = json['beforeMenstrualCycleMemo'];
    menstrualCycleStartDt = json['menstrualCycleStartDt'];
    menstrualCycleEndDt = json['menstrualCycleEndDt'];
    menstrualCycleMemo = json['menstrualCycleMemo'];
    afterMenstrualCycleStartDt = json['afterMenstrualCycleStartDt'];
    afterMenstrualCycleEndDt = json['afterMenstrualCycleEndDt'];
    afterMenstrualCycleMemo = json['afterMenstrualCycleMemo'];
    ovulationDt = json['ovulationDt'];
    ovulationDtMemo = json['ovulationDtMemo'];
    afterOvulationDt = json['afterOvulationDt'];
    afterOvulationDtMemo = json['afterOvulationDtMemo'];
    fertileWindowStartDt = json['fertileWindowStartDt'];
    fertileWindowEndDt = json['fertileWindowEndDt'];
    fertileWindowMemo = json['fertileWindowMemo'];
    afterFertileWindowStartDt = json['afterFertileWindowStartDt'];
    afterFertileWindowEndDt = json['afterFertileWindowEndDt'];
    afterFertileWindowMemo = json['afterFertileWindowMemo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isValid'] = this.isValid;
    data['beforeMenstrualCycleStartDt'] = this.beforeMenstrualCycleStartDt;
    data['beforeMenstrualCycleEndDt'] = this.beforeMenstrualCycleEndDt;
    data['beforeMenstrualCycleMemo'] = this.beforeMenstrualCycleMemo;
    data['menstrualCycleStartDt'] = this.menstrualCycleStartDt;
    data['menstrualCycleEndDt'] = this.menstrualCycleEndDt;
    data['menstrualCycleMemo'] = this.menstrualCycleMemo;
    data['afterMenstrualCycleStartDt'] = this.afterMenstrualCycleStartDt;
    data['afterMenstrualCycleEndDt'] = this.afterMenstrualCycleEndDt;
    data['afterMenstrualCycleMemo'] = this.afterMenstrualCycleMemo;
    data['ovulationDt'] = this.ovulationDt;
    data['ovulationDtMemo'] = this.ovulationDtMemo;
    data['afterOvulationDt'] = this.afterOvulationDt;
    data['afterOvulationDtMemo'] = this.afterOvulationDtMemo;
    data['fertileWindowStartDt'] = this.fertileWindowStartDt;
    data['fertileWindowEndDt'] = this.fertileWindowEndDt;
    data['fertileWindowMemo'] = this.fertileWindowMemo;
    data['afterFertileWindowStartDt'] = this.afterFertileWindowStartDt;
    data['afterFertileWindowEndDt'] = this.afterFertileWindowEndDt;
    data['afterFertileWindowMemo'] = this.afterFertileWindowMemo;
    return data;
  }
}
