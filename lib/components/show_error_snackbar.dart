import 'package:akane_vote/utils/utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void showErrorSnackBar(BuildContext context,
String title, String message) {
  Flushbar(
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    flushbarPosition: FlushbarPosition.TOP,
    titleText: Text(title, style: GoogleFonts.openSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white
    ),),
    messageText: Text(message,
    style: GoogleFonts.openSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white
    ),),
    duration:  const Duration(seconds: 4),
    backgroundColor: HexColor.fromHex(kErrorColor),
    icon: const Icon(LucideIcons.octagonAlert, color: Colors.white,),
  ).show(context);
}