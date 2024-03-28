class CoupleUnResolvedSignalDto {
  bool? hasUnResolved;

  int? eatSignalSeq;
  int? playSignalSeq;
  int? messageOfTheDaySeq;
  int? todaySignalSeq;

  CoupleUnResolvedSignalDto({
    this.hasUnResolved, this.eatSignalSeq, this.playSignalSeq, this.messageOfTheDaySeq, this.todaySignalSeq
  });

  CoupleUnResolvedSignalDto.fromJson(Map<String, dynamic> json)
      :
        hasUnResolved = json['hasUnResolved'],

        eatSignalSeq = json['eatSignalSeq'],
        playSignalSeq = json['playSignalSeq'],
        messageOfTheDaySeq = json['messageOfTheDaySeq'],
        todaySignalSeq = json['todaySignalSeq'];

}
