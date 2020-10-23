import 'package:flutter/material.dart';

class CardDetailPage extends StatelessWidget {
  final String card;
  final String cardUrl;

  CardDetailPage({Key key, @required this.card, @required this.cardUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        body: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Center(
                child: Container(
                    margin: EdgeInsetsDirectional.only(top: 60, end: 2),
                    color: Colors.transparent,
                    height: 450,
                    width: 300,
                    child: Center(
                      child: Hero(
                        tag: '${card}_$cardUrl',
                        child: Image(
                          image: NetworkImage(cardUrl),
                          fit: BoxFit.contain,
                          width: 300,
                          height: 500,
                        ),
                      ),
                    )),
              ),
            )));
  }
}
