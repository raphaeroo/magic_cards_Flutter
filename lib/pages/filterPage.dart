import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:magic_cards/theme/color.dart';

import 'cardDetail.dart';

class FilterCardPage extends StatefulWidget {
  final String colorName;

  FilterCardPage({this.colorName});
  @override
  _FilterCardPageState createState() =>
      _FilterCardPageState(colorName: colorName);
}

class _FilterCardPageState extends State<FilterCardPage> {
  final String colorName;

  _FilterCardPageState({this.colorName});

  List cards = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchCards();
  }

  fetchCards() async {
    setState(() {
      isLoading = true;
    });

    var normalizeColor = colorName.toLowerCase();
    var url =
        'https://api.magicthegathering.io/v1/cards?page=0&pageSize=30&contains=imageUrl&colors=$normalizeColor';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['cards'];
      setState(() {
        cards = items;
        isLoading = false;
      });
    } else {
      setState(() {
        cards = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Filtro: $colorName Cards'),
        ),
        body: getBody());
  }

  Widget getBody() {
    if (cards.contains(null) || cards.length < 0 || isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(primary),
        ),
      );
    }
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (BuildContext context, int index) {
        return getCard(cards[index]);
      },
    );
  }

  Widget getCard(card) {
    var cardName = card['name'];
    var cardType = card['type'];
    var cardImage = card['imageUrl'];
    var cardColors = card['colors'];

    var fallbackImage =
        'https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/1/8/6/0/230681-6-eng-GB/IB3-Limited-SIC-Pharma-April-20142_news_large.jpg';

    var getColors = (color) {
      switch (color) {
        case 'green':
          return Colors.green;
        case 'blue':
          return Colors.blue;
        case 'black':
          return Colors.black;
        case 'red':
          return Colors.red;
        case 'white':
          return Colors.white;
        default:
          return Colors.deepPurpleAccent[400];
      }
    };

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, __, _) => CardDetailPage(
                  card: cardName,
                  prefix: 'filterPage',
                  cardUrl: cardImage != null ? cardImage : fallbackImage))),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
              child: Row(
            children: <Widget>[
              Hero(
                tag: 'filterPage_${cardName}_$cardImage',
                child: Image(
                  image: NetworkImage(
                      cardImage != null ? cardImage : fallbackImage),
                  fit: BoxFit.contain,
                  width: 60,
                  height: 80,
                ),
              ),
              SizedBox(width: 15),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Text('Nome: ',
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(width: 3),
                        Container(
                          width: 210,
                          child: Text(cardName,
                              maxLines: 3, style: TextStyle(fontSize: 14)),
                        ),
                      ]),
                      SizedBox(height: 10),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Tipo: ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(width: 3),
                            Container(
                              width: 210,
                              child: Text(cardType,
                                  maxLines: 3, style: TextStyle(fontSize: 14)),
                            ),
                          ]),
                      SizedBox(height: 10),
                      cardColors.length >= 1
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  Text('Cor: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 3),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        color: getColors(
                                            cardColors[0].toLowerCase()),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(7.5)),
                                  )
                                ])
                          : Container(),
                    ]),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
