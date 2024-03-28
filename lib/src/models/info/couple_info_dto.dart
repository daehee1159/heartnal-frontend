class CoupleInfoDto {
  String? coupleNickName;
  String? coupleCode;
  String? coupleRegDt;

  CoupleInfoDto.fromJson(Map<String, dynamic> json) {
    coupleNickName = json['coupleNickName'];
    coupleCode = json['coupleCode'];
    coupleRegDt = json['coupleRegDt'];
  }
  CoupleInfoDto(String coupleNickName, String coupleCode, String coupleRegDt) {
    this.coupleNickName = coupleNickName;
    this.coupleCode = coupleCode;
    this.coupleRegDt = coupleRegDt;
  }
}
