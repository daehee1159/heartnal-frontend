import 'package:flutter/material.dart';

class CoupleBalanceGameMain extends StatefulWidget {
  const CoupleBalanceGameMain({Key? key}) : super(key: key);

  @override
  State<CoupleBalanceGameMain> createState() => _CoupleBalanceGameMainState();
}

class _CoupleBalanceGameMainState extends State<CoupleBalanceGameMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '커플 밸런스 게임',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.blue,
                  ),
                ),
                Positioned(
                  top: constraints.biggest.height * .20,
                  // top: 100,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.30,
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      // color: Colors.yellow,
                      borderRadius: BorderRadius.all(
                        Radius.circular(13.0)
                      )
                    ),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0)
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  // color: Colors.green,
                ),

              ],
            ),
          );
        }
      )
    );
  }
}
