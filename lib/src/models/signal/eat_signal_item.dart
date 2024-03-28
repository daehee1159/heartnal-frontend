import 'package:flutter/material.dart';

class EatSignalItem extends ChangeNotifier {
  getEatSignalCategoryList() {
    var categoryList = ['한식/분식', '아시안/양식', '중식/일식', '고기', '디저트', '보양식', '랜덤 선택'];
    return categoryList;
  }

  getEatSignalCategory(categoryName) {
    var category = [];
    switch (categoryName) {
      case '한식/분식':
        category = ['김치찌개', '된장찌개', '순두부찌개', '부대찌개', '찜닭', '해물찜', '갈비찜', '아구찜', '김치찜', '국밥', '게장', '죽', '백반', '감자탕', '해장국', '비빔밥', '한식 뷔페', '육개장', '쭈꾸미', '냉면', '떡볶이', '분식', '칼국수', '콩국수', '랜덤 선택'];
        break;
      case '아시안/양식':
        category = ['뷔페', '파스타', '스테이크', '피자', '햄버거', '케밥', '쌀국수', '타코', '랜덤 선택'];
        break;
      case '중식/일식':
        category = ['돈부리', '카레', '돈까스', '라멘', '회', '초밥', '짜장면', '마라탕', '훠궈', '랜덤 선택'];
        break;
      case '고기':
        category = ['삼겹살', '갈비', '소고기', '육회', '막창', '곱창', '닭발', '족발', '보쌈', '치킨', '차돌박이', '닭구이', '양꼬치', '랜덤 선택'];
        break;
      case '디저트':
        category = ['와플', '아이스크림', '커피', '도넛', '케익', '핫도그', '샌드위치', '빵', '빙수', '타르트', '파이', '츄러스', '랜덤 선택'];
        break;
      case '보양식':
        category = ['삼계탕', '오리탕', '추어탕', '장어', '곰탕', '설렁탕', '연포탕', '갈비탕', '해신탕', '도가니탕', '랜덤 선택'];
        break;
    }

    return category;
  }

  getEatSignalCategoryImgAddr(itemName) {
    var imgAddr;
    switch (itemName) {
      case '한식/분식':
        imgAddr = 'images/korean_food.png';
        break;
      case '아시안/양식':
        imgAddr = 'images/western_food.png';
        break;
      case '중식/일식':
        imgAddr = 'images/chinese_food.png';
        break;
      case '고기':
        imgAddr = 'images/pork_belly.png';
        break;
      case '디저트':
        imgAddr = 'images/dessert.png';
        break;
      case '보양식':
        imgAddr = 'images/samgyetang.png';
        break;
      case '랜덤 선택':
        imgAddr = 'images/random_choice_2.png';
        break;
    }
    return imgAddr;
  }

  getEatSignalItemImgAddr(itemName) {
    var imgAddr;
    switch (itemName) {
      case '김치찌개':
        imgAddr = 'images/gimchijjigae.png';
        break;
      case '된장찌개':
        imgAddr = 'images/doenjangjjigae.png';
        break;
      case '순두부찌개':
        imgAddr = 'images/sundubujjigae.png';
        break;
      case '부대찌개':
        imgAddr = 'images/budaejjigae.png';
        break;
      case '찜닭':
        imgAddr = 'images/jjimdalg.png';
        break;
      case '해물찜':
        imgAddr = 'images/haemuljjim.png';
        break;
      case '갈비찜':
        imgAddr = 'images/galbijjim.png';
        break;
      case '아구찜':
        imgAddr = 'images/agujjim.png';
        break;
      case '김치찜':
        imgAddr = 'images/gimchijjim.png';
        break;
      case '국밥':
        imgAddr = 'images/gugbab.png';
        break;
      case '게장':
        imgAddr = 'images/gejang.png';
        break;
      case '죽':
        imgAddr = 'images/jug.png';
        break;
      case '백반':
        imgAddr = 'images/baegban.png';
        break;
      case '감자탕':
        imgAddr = 'images/gamjatang.png';
        break;
      case '해장국':
        imgAddr = 'images/haejanggug.png';
        break;
      case '비빔밥':
        imgAddr = 'images/bibimbab.png';
        break;
      case '한식 뷔페':
        imgAddr = 'images/korean_buffet.png';
        break;
      case '육개장':
        imgAddr = 'images/yuggaejang.png';
        break;
      case '쭈꾸미':
        imgAddr = 'images/jjukkumi.png';
        break;
      case '냉면':
        imgAddr = 'images/naengmyeon.png';
        break;
      case '떡볶이':
        imgAddr = 'images/tteogbokki.png';
        break;
      case '분식':
        imgAddr = 'images/snack_bar.png';
        break;
      case '칼국수':
        imgAddr = 'images/kalgugsu.png';
        break;
      case '콩국수':
        imgAddr = 'images/konggugsu.png';
        break;
      case '랜덤 선택':
        imgAddr = 'images/random_choice_2.png';
        break;
      case '뷔페':
        imgAddr = 'images/buffet.png';
        break;
      case '파스타':
        imgAddr = 'images/pasta.png';
        break;
      case '스테이크':
        imgAddr = 'images/steak.png';
        break;
      case '피자':
        imgAddr = 'images/pizza.png';
        break;
      case '햄버거':
        imgAddr = 'images/hamburger.png';
        break;
      case '케밥':
        imgAddr = 'images/kebab.png';
        break;
      case '쌀국수':
        imgAddr = 'images/rice_noodles.png';
        break;
      case '타코':
        imgAddr = 'images/tacos.png';
        break;
      case '돈부리':
        imgAddr = 'images/donburi.jpg';
        break;
      case '카레':
        imgAddr = 'images/curry.png';
        break;
      case '돈까스':
        imgAddr = 'images/pork_cutlet.png';
        break;
      case '라멘':
        imgAddr = 'images/ramen.png';
        break;
      case '회':
        imgAddr = 'images/sashimi.png';
        break;
      case '초밥':
        imgAddr = 'images/sushi.png';
        break;
      case '짜장면':
        imgAddr = 'images/jajangmyeon.png';
        break;
      case '마라탕':
        imgAddr = 'images/malatang.png';
        break;
      case '훠궈':
        imgAddr = 'images/hwo_gwo.png';
        break;
      case '삼겹살':
        imgAddr = 'images/pork_belly.png';
        break;
      case '갈비':
        imgAddr = 'images/rib.png';
        break;
      case '소고기':
        imgAddr = 'images/beef.png';
        break;
      case '육회':
        imgAddr = 'images/raw_meat.png';
        break;
      case '막창':
        imgAddr = 'images/mak_chang.png';
        break;
      case '곱창':
        imgAddr = 'images/giblets.png';
        break;
      case '닭발':
        imgAddr = 'images/chicken_feet.png';
        break;
      case '족발':
        imgAddr = 'images/pork_feet.png';
        break;
      case '보쌈':
        imgAddr = 'images/bossam.png';
        break;
      case '치킨':
        imgAddr = 'images/chicken.png';
        break;
      case '차돌박이':
        imgAddr = 'images/beef_brisket.png';
        break;
      case '닭구이':
        imgAddr = 'images/roast_chicken.png';
        break;
      case '양꼬치':
        imgAddr = 'images/lamb_skewers.png';
        break;
      case '와플':
        imgAddr = 'images/waffle.png';
        break;
      case '아이스크림':
        imgAddr = 'images/ice_cream.png';
        break;
      case '커피':
        imgAddr = 'images/coffee.png';
        break;
      case '도넛':
        imgAddr = 'images/donut.png';
        break;
      case '케익':
        imgAddr = 'images/cake.png';
        break;
      case '핫도그':
        imgAddr = 'images/hot_dog.png';
        break;
      case '샌드위치':
        imgAddr = 'images/sandwich.png';
        break;
      case '빵':
        imgAddr = 'images/bread.png';
        break;
      case '빙수':
        imgAddr = 'images/shaved_ice.png';
        break;
      case '타르트':
        imgAddr = 'images/tart.png';
        break;
      case '파이':
        imgAddr = 'images/pie.png';
        break;
      case '츄러스':
        imgAddr = 'images/churros.png';
        break;
      case '삼계탕':
        imgAddr = 'images/samgyetang.png';
        break;
      case '오리탕':
        imgAddr = 'images/olitang.png';
        break;
      case '추어탕':
        imgAddr = 'images/chueotang.png';
        break;
      case '장어':
        imgAddr = 'images/eel.png';
        break;
      case '곰탕':
        imgAddr = 'images/gomtang.png';
        break;
      case '설렁탕':
        imgAddr = 'images/sullungtang.png';
        break;
      case '연포탕':
        imgAddr = 'images/yeonpotang.png';
        break;
      case '갈비탕':
        imgAddr = 'images/galbitang.png';
        break;
      case '해신탕':
        imgAddr = 'images/haesintang.png';
        break;
      case '도가니탕':
        imgAddr = 'images/doganitang.png';
        break;
    }
    return imgAddr;
  }

}
