import 'package:flutter/material.dart';

class PlaySignalItem extends ChangeNotifier {
  getPlaySignalCategoryList() {
    var categoryList = ['일상 데이트', '이색 데이트', '산책/드라이브', '스포츠/레저', '공부/문화', '랜덤 선택'];
    return categoryList;
  }

  getPlaySignalCategory(categoryName) {
    var category = [];
    switch (categoryName) {
      case '일상 데이트':
        category = ['카페', '영화', '연극', '쇼핑', '코인 노래방','한잔 할래?', '라면먹고 갈래?', '랜덤 선택'];
        break;
      case '이색 데이트':
        category = ['자동차 극장', '피시방', '방탈출 카페', '만화 카페', '공방', '롤러장', 'VR 게임방', '보드카페', '찜질방', '랜덤 선택'];
        break;
      case '산책/드라이브':
        category = ['공원', '드라이브', '랜덤 선택'];
        break;
      case '스포츠/레저':
        category = ['볼링', '탁구', '당구', '스크린 야구', '스크린 골프', '랜덤 선택'];
        break;
      case '공부/문화':
        category = ['미술관', '식물원', '동물원', '도서관', '서점', '랜덤 선택'];
        break;
    }

    return category;
  }

  getPlaySignalCategoryImgAddr(itemName) {
    var imgAddr;
    switch (itemName) {
      case '일상 데이트':
        imgAddr = 'images/daily_date.png';
        break;
      case '이색 데이트':
        imgAddr = 'images/work_shop.png';
        break;
      case '산책/드라이브':
        imgAddr = 'images/park.png';
        break;
      case '스포츠/레저':
        imgAddr = 'images/bowling.png';
        break;
      case '공부/문화':
        imgAddr = 'images/art_gallery.png';
        break;
      case '랜덤 선택':
        imgAddr = 'images/random_choice_2.png';
        break;
    }
    return imgAddr;
  }

  getPlaySignalItemImgAddr(itemName) {
    var imgAddr;
    switch (itemName) {
      case '카페':
        imgAddr = 'images/cafe.png';
        break;
      case '라면먹고 갈래?':
        imgAddr = 'images/signal.png';
        break;
      case '스크린 야구':
        imgAddr = 'images/screen_baseball.png';
        break;
      case '스크린 골프':
        imgAddr = 'images/screen_golf.png';
        break;
      case '볼링':
        imgAddr = 'images/bowling.png';
        break;
      case '탁구':
        imgAddr = 'images/ping_pong.png';
        break;
      case '당구':
        imgAddr = 'images/billiards.png';
        break;
      case '영화':
        imgAddr = 'images/cinema.png';
        break;
      case '공원':
        imgAddr = 'images/park.png';
        break;
      case '자동차 극장':
        imgAddr = 'images/car_theater.png';
        break;
      case '연극':
        imgAddr = 'images/theater.png';
        break;
      case '쇼핑':
        imgAddr = 'images/shopping.png';
        break;
      case '피시방':
        imgAddr = 'images/internet_cafe.png';
        break;
      case '방탈출 카페':
        imgAddr = 'images/escape_room_cafe.png';
        break;
      case '드라이브':
        imgAddr = 'images/drive.png';
        break;
      case '만화 카페':
        imgAddr = 'images/cartoon_cafe.png';
        break;
      case '공방':
        imgAddr = 'images/work_shop.png';
        break;
      case '롤러장':
        imgAddr = 'images/roller_rink.png';
        break;
      case 'VR 게임방':
        imgAddr = 'images/vr_game_room.png';
        break;
      case '보드카페':
        imgAddr = 'images/board_game_room.png';
        break;
      case '코인 노래방':
        imgAddr = 'images/coin_karaoke.png';
        break;
      case '식물원':
        imgAddr = 'images/botanical_garden.png';
        break;
      case '놀이공원':
        imgAddr = 'images/amusement.png';
        break;
      case '동물원':
        imgAddr = 'images/zoo.png';
        break;
      case '미술관':
        imgAddr = 'images/art_gallery.png';
        break;
      case '도서관':
        imgAddr = 'images/library.png';
        break;
      case '서점':
        imgAddr = 'images/bookstore.png';
        break;
      case '한잔 할래?':
        imgAddr = 'images/have_a_drink.png';
        break;
      case '찜질방':
        imgAddr = 'images/korean_sauna.png';
        break;
      case '랜덤 선택':
        imgAddr = 'images/random_choice_2.png';
        break;
    }
    return imgAddr;
  }

}
