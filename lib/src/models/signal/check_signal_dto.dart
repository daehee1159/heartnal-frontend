class CheckSignalDto {
  bool? hasUnResolved;

  int? senderEatSignalSeq;
  int? senderPlaySignalSeq;

  int? recipientEatSignalSeq;
  int? recipientPlaySignalSeq;

  CheckSignalDto({
    this.hasUnResolved, this.senderEatSignalSeq, this.senderPlaySignalSeq,
    this.recipientEatSignalSeq, this.recipientPlaySignalSeq
  });

  CheckSignalDto.fromJson(Map<String, dynamic> json)
      :
        hasUnResolved = json['hasUnResolved'],

        senderEatSignalSeq = json['senderEatSignalSeq'],
        senderPlaySignalSeq = json['senderPlaySignalSeq'],

        recipientEatSignalSeq = json['recipientEatSignalSeq'],
        recipientPlaySignalSeq = json['recipientPlaySignalSeq'];

}
