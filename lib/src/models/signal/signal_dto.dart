/// FCM Dto
class SignalDto {
  String? click_action;
  String? sound;
  String? status;
  String? screen;
  String? testData;

  String? isSignal;

  // 오늘 뭐먹지 1차 선택시 1차 recipient 가 받을 때 필요한 데이터
  String? position;
  String? category;
  String? tryCount;

  String? eatSignalSeq;
  String? playSignalSeq;
  String? messageOfTheDaySeq;
  String? todaySignalSeq;
  String? tempSignalSeq;

  String? senderSelected;
  String? recipientSelected;
  String? termination;
  String? result;
  String? resultSelected;

  SignalDto(
      this.click_action, this.sound, this.status, this.screen, this.testData,
      this.isSignal,
      this.position, this.category, this.tryCount,
      this.eatSignalSeq, this.playSignalSeq, this.messageOfTheDaySeq, this.todaySignalSeq, this.tempSignalSeq,
      this.senderSelected, this.recipientSelected, this.termination, this.result, this.resultSelected
      );

  SignalDto.fromJson(Map<dynamic, dynamic> json)
  : click_action = json['click_action'],
    sound = json['sound'],
    status = json['status'],
    screen = json['screen'],
    testData = json['testData'],

    isSignal = json['isSignal'],

    position = json['position'],
    category = json['category'],
    tryCount = json['tryCount'],

    eatSignalSeq = json['eatSignalSeq'],
    playSignalSeq = json['playSignalSeq'],
    messageOfTheDaySeq = json['messageOfTheDaySeq'],
    todaySignalSeq = json['todaySignalSeq'],
    tempSignalSeq = json['tempSignalSeq'],

    senderSelected = json['senderSelected'],
    recipientSelected = json['recipientSelected'],
    termination = json['termination'],
    result = json['result'],
    resultSelected = json['resultSelected'];

  Map<dynamic, dynamic> toJson() => {
    'click_action' : click_action,
    'sound' : sound,
    'status' : status,
    'screen' : screen,
    'testData' : testData,

    'isSignal': isSignal,

    'position' : position,
    'category' : category,
    'tryCount' : tryCount,

    'eatSignalSeq' : eatSignalSeq,
    'playSignalSeq' : playSignalSeq,
    'messageOfTheDaySeq' : messageOfTheDaySeq,
    'todaySignalSeq': todaySignalSeq,
    'tempSignalSeq' : tempSignalSeq,

    'senderSelected' : senderSelected,
    'recipientSelected' : recipientSelected,
    'termination' : termination,
    'result' : result,
    'resultSelected' : resultSelected
  };
}
