import 'package:flutter/material.dart';
import 'package:magic_cards/pages/filterPage.dart';
import 'package:magic_cards/theme/color.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({
    this.onPressed,
    this.tooltip,
    this.icon,
  });

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 40;

  void onColorPress(colorName) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FilterCardPage(colorName: colorName)),
    );
  }

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    _buttonColor = ColorTween(
      begin: primary,
      end: Colors.grey,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight - 10,
      end: -10.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget blue() {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
        child: new RawMaterialButton(
          shape: new CircleBorder(),
          elevation: 0.0,
          onPressed: () => onColorPress('Blue'),
        ));
  }

  Widget green() {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(20)),
        child: new RawMaterialButton(
          shape: new CircleBorder(),
          elevation: 0.0,
          onPressed: () => onColorPress('Green'),
        ));
  }

  Widget white() {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 1)),
        child: new RawMaterialButton(
            shape: new CircleBorder(),
            elevation: 0.0,
            onPressed: () => onColorPress('White')));
  }

  Widget black() {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
        child: new RawMaterialButton(
          shape: new CircleBorder(),
          elevation: 0.0,
          onPressed: () => onColorPress('Black'),
        ));
  }

  Widget red() {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(20)),
        child: new RawMaterialButton(
          shape: new CircleBorder(),
          elevation: 0.0,
          onPressed: () => onColorPress('Red'),
        ));
  }

  Widget toggle() {
    return Container(
      width: 45,
      height: 45,
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: Icon(Icons.filter_alt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 5.0,
            0.0,
          ),
          child: green(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 4.0,
            0.0,
          ),
          child: white(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: blue(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: black(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: red(),
        ),
        toggle(),
      ],
    );
  }
}
