class CoupleCodeDto {
  String? username;
  String? coupleCode;
  String? message;

  CoupleCodeDto.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    coupleCode = json['coupleCode'];
    message = json['message'];
  }
}
