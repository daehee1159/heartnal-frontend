class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'images/main_1.png',
    title: '하트널 서비스 소개',
    description: '너에게 보내는 \n나의 시그널 ( . ̫ .)💗 ',
  ),
  Slide(
    imageUrl: 'images/main_2.png',
    title: '하트널 서비스 소개2',
    description: '오늘 뭐먹지? 오늘 뭐하지? \n고민은 그만❗',
  ),
  Slide(
    imageUrl: 'images/main_3.png',
    title: '하트널 서비스 소개3',
    description: '하트널을 통해\n서로의 마음을 확인해보세요💗'
  ),
];
