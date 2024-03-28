class NotificationDto {
  String? type;
  String? message;
  String? regDt;

  String? username;

  NotificationDto({this.type, this.message, this.regDt});

  NotificationDto.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
    regDt = json['regDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['type'] = this.type;
    data['message'] = this.message;
    data['regDt'] = this.regDt;
    return data;
  }
}
