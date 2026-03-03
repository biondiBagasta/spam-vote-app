import "package:akane_vote/utils/utils.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MainTextComponent extends StatelessWidget {

  const MainTextComponent({ super.key, required this.text, required this.fontSize, required this.fontWeight, this.textAlign = TextAlign.left,
  this.textOverflow = TextOverflow.ellipsis, this.maxLines = 2, this.isWhite = false });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow textOverflow;
  final int? maxLines;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
      style: GoogleFonts.openSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: 
        isWhite ? Colors.white :
        HexColor.fromHex(kTextColor)
      ),
    );
  }
}