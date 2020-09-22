import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'trash_bin.dart';

class SlidingPanel extends StatefulWidget {
  const SlidingPanel({
    this.index,
    this.onTap,
    this.subtitleText,
    this.trailingText,
    this.titleText,
    this.firstGradient,
    this.secondGradient,
    this.shadowColor,
    this.subtitleColor,
    this.titleColor,
    this.trailingColor,
  });
  final int index;
  final Function onTap;
  final String subtitleText;
  final String trailingText;
  final String titleText;
  final Color firstGradient;
  final Color secondGradient;
  final Color shadowColor;
  final Color trailingColor;
  final Color titleColor;
  final Color subtitleColor;
  @override
  _SlidingPanelState createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        actions: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: IconSlideAction(
              iconWidget: TrashCan(),
              color: Colors.transparent,
              onTap: widget.onTap,
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  widget.firstGradient,
                  widget.secondGradient,
                ],
                end: Alignment.topRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor,
                  blurRadius: 1,
                  offset: const Offset(3, 0),
                  spreadRadius: 2,
                )
              ],
            ),
            child: Center(
              child: ListTile(
                hoverColor: Colors.red,
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    './assets/images/pumpkin.png',
                    fit: BoxFit.cover,
                  ),
                  foregroundColor: Colors.white,
                ),
                title: Text(
                  widget.titleText,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: widget.titleColor,
                  ),
                ),
                subtitle: Text(
                  widget.subtitleText,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: widget.subtitleColor,
                  ),
                ),
                trailing: Text(widget.trailingText,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: widget.trailingColor,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
