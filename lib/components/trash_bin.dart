import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TrashCan extends StatefulWidget {
  @override
  _TrashCanState createState() => _TrashCanState();
}

class _TrashCanState extends State<TrashCan> {
  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      'https://assets8.lottiefiles.com/packages/lf20_VmD8Sl.json',
      width: 350,
    );
  }
}
