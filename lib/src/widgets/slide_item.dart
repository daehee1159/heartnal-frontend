import 'package:couple_signal/src/models/slide.dart';
import 'package:flutter/material.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        // Text(
        //   slideList[index].title,
        //   style: TextStyle(
        //     fontSize: 22,
        //   ),
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, 0, 0),
          child: Text(
            slideList[index].description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}
