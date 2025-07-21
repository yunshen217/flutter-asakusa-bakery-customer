import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shopping_client/common/custom_color.dart';

import '../common/custom_widget.dart';
import '../model/GoodModel.dart';

class AddToCartCounterButton extends StatefulWidget {
  /// The init value of the `AddToCartCounterButton`.
  ///
  /// This property determines the initial value taken by the counter.
  final num initNumber;

  /// The counterCallback of the `AddToCartCounterButton`.
  ///
  /// This method is a callback method with current value of the counter
  /// as the argument, invoked whenever there is a change in counter
  /// value due to any action.
  final Function(int) counterCallback;

  /// The increaseCallback of the `AddToCartCounterButton`.
  ///
  /// This is callback method which is invoked whenever the counter value is
  /// incremented.
  ///
  final Function increaseCallback;

  /// The decreaseCallback of the `AddToCartCounterButton`.
  ///
  /// This is callback method which is invoked whenever the counter value is
  /// decremented.
  ///
  final Function decreaseCallback;

  /// The min value of the `AddToCartCounterButton`.
  ///
  /// This property determines min value that could be taken by the counter
  final int minNumber;

  /// The max value of the `AddToCartCounterButton`.
  ///
  /// This property determines max value that could be taken by the counter
  final int maxNumber;

  /// The background color of the `AddToCartCounterButton`.
  ///
  /// This property determines background color for the entire button
  final Color backgroundColor;

  /// The icon color of the `AddToCartCounterButton`.
  ///
  /// This property determines foreground color for the icons of the counter
  /// button and the button text
  final Color buttonIconColor;

  /// The fill color of the `AddToCartCounterButton`.
  ///
  /// This property determines background color of the counter button
  final Color buttonFillColor;
  final List<GoodModel>? mData;
  final num? maxPrice;
  final int? index;

  /// Constructor for `AddToCartCounterButton`.
  ///
  /// This constructor initializes the counter button with the specified
  /// background and fill colors and various other parameters.
  /// Also allows you to define max and min limit for the counter.
  const AddToCartCounterButton(
      {this.initNumber = 0,
      required this.counterCallback,
      required this.decreaseCallback,
      required this.increaseCallback,
      this.minNumber = 0,
      this.index = 0,
      required this.maxNumber,
      required this.backgroundColor,
      required this.buttonIconColor,
      required this.buttonFillColor,
      required this.mData,
      required this.maxPrice,
      super.key});

  @override
  _AddToCartCounterButtonState createState() => _AddToCartCounterButtonState();
}

class _AddToCartCounterButtonState extends State<AddToCartCounterButton> {
  num _currentCount = 0;
  Function _counterCallback = (int number) {};
  Function _increaseCallback = () {};
  Function _decreaseCallback = () {};
  int _minNumber = 0;
  int _maxNumber = 100;
  Color _backgroundColor = CustomColor.grayC5;
  Color _buttonIconColor = Colors.black;
  Color _buttonFillColor = Colors.white;

  @override
  void didUpdateWidget(covariant AddToCartCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.initNumber != widget.initNumber) {
    //
    // }
    _currentCount = widget.initNumber;
    _maxNumber = widget.maxNumber;
  }

  @override
  void initState() {
    _currentCount = widget.initNumber;
    _counterCallback = widget.counterCallback;
    _increaseCallback = widget.increaseCallback;
    _decreaseCallback = widget.decreaseCallback;
    _maxNumber = widget.maxNumber;
    _minNumber = widget.minNumber;
    _backgroundColor = widget.backgroundColor;
    _buttonIconColor = widget.buttonIconColor;
    _buttonFillColor = widget.buttonFillColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: _backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _createIncrementDecrementButton(Icons.remove, () => _decrease()),
          Text(_currentCount.toString(),
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
          _createIncrementDecrementButton(Icons.add, () => _increment())
        ],
      ),
    );
  }

  num localPrice = 0;

  void _increment() {
    List<GoodModel>? data = widget.mData?.where((e) => e.itemCount! > 0).toList();
    localPrice = 0;
    if (data!.isNotEmpty) {
      for (var e in data) {
        localPrice += e.price! * e.itemCount!;
      }
    }
    // 计算增加后的总价格
    num newTotalPrice = localPrice + widget.mData![widget.index!].price!;

    if (newTotalPrice > widget.maxPrice!) {
      customWidget.toastShow("注文金額が${widget.maxPrice}を超える場合、店舗にお電話でお問い合わせください。",
          notifyType: NotifyType.warning);
      return;
    }
    setState(() {
      print(_currentCount);
      print(_maxNumber);
      if (_currentCount < _maxNumber) {
        _currentCount++;
        _increaseCallback();
      }
      // print("$_currentCount");
      _currentCount = _currentCount;
      _counterCallback(_currentCount);
    });
  }

  void _decrease() {
    setState(() {
      if (_currentCount > _minNumber) {
        _currentCount--;
        _counterCallback(_currentCount);
        _decreaseCallback();
      }
    });
  }

  Widget _createIncrementDecrementButton(IconData icon, void Function() onPressed) {
    return RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        constraints: const BoxConstraints(minHeight: 30.0, minWidth: 30.0),
        elevation: 0.0,
        padding: const EdgeInsets.all(10),
        fillColor: _buttonFillColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: onPressed,
        child: Icon(icon, color: _buttonIconColor, size: 12.0));
  }
}
