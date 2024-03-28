enum TodaySignalResultMessageType {
  score60, score90, score100
}

extension MessageTypeExtension on TodaySignalResultMessageType {
  String get convertText {
    switch (this) {
      case TodaySignalResultMessageType.score60:
        return "아쉽지만 내일 다시 도전해 봐요!";
      case TodaySignalResultMessageType.score90:
        return "내일은 무조건 100점!!";
      case TodaySignalResultMessageType.score100:
        return "축하해요!\n서로 너무 잘 맞는 커플이네요!";
    }
  }
}
