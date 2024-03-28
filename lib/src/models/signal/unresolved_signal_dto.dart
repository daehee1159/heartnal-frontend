class UnResolvedSignalDto {
  String? position;
  String? category;
  int? tryCount;

  int? eatSignalSeq;
  int? playSignalSeq;

  String? senderSelected;
  String? recipientSelected;

  UnResolvedSignalDto.fromJson(Map<String, dynamic> json)
  :
      position = json['position'],
      category = json['category'],
      tryCount = json['tryCount'],
      eatSignalSeq = json['eatSignalSeq'],
      playSignalSeq = json['playSignalSeq'],
      senderSelected = json['senderSelected'],
      recipientSelected = json['recipientSelected'];
}
