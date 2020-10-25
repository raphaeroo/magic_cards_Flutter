import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_cards/components/floatingAction.dart';
import 'package:magic_cards/theme/color.dart';

import 'package:http/http.dart' as http;

import 'cardDetail.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List cards = new List();
  bool isLoading = false;

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List filteredCards = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Magic Cards');

  _IndexPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredCards = cards;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.fetchCards();
  }

  fetchCards() async {
    setState(() {
      isLoading = true;
    });
    var url =
        'https://api.magicthegathering.io/v1/cards?page=0&pageSize=100&contains=imageUrl';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['cards'];
      List tempList = new List();

      for (int i = 0; i < items.length; i++) {
        tempList.add(items[i]);
      }

      setState(() {
        cards = items;
        filteredCards = tempList;
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
          title: _appBarTitle,
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ],
        ),
        floatingActionButton: FancyFab(),
        body: getBody());
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            disabledBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: 'Procurar...',
            hintStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text('Magic Cards');
        filteredCards = cards;
        _filter.clear();
      }
    });
  }

  Widget getBody() {
    if (cards.contains(null) || cards.length < 0 || isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(primary),
        ),
      );
    }

    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredCards.length; i++) {
        if (filteredCards[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredCards[i]);
        }
      }
      filteredCards = tempList;
    }

    return ListView.builder(
      itemCount: filteredCards.length,
      itemBuilder: (BuildContext context, int index) {
        return getCard(filteredCards[index]);
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
                  prefix: 'homePage',
                  cardUrl: cardImage != null ? cardImage : fallbackImage))),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
              child: Row(
            children: <Widget>[
              Hero(
                tag: 'homePage_${cardName}_$cardImage',
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
