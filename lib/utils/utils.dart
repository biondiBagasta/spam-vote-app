import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackgroundColor = "#ffffff";
const kPrimaryColor = "#233C7D";
const kTextColor = "#2B2B2B";
const kErrorColor = "#e74c3c";

const kSupabaseUrl = "https://osslvsxiaqpqiqyarerr.supabase.co";
const kSupabaseApiKey = "sb_publishable_GneMYaHwOXG2em7IlT-x4w_jBOQrvIV";


extension HexColor on Color {
  /// Create a Color from a hex code string like "#aabbcc" or "ffaabbcc".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert a Color to hex string. Adds "#" by default.
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${a.toInt().toRadixString(16).padLeft(2, '0')}'
      '${r.toInt().toRadixString(16).padLeft(2, '0')}'
      '${g.toInt().toRadixString(16).padLeft(2, '0')}'
      '${b.toInt().toRadixString(16).padLeft(2, '0')}';
}

final double constantScreenWidth = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.width /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  
final double constantScreenHeight = WidgetsBinding
              .instance.platformDispatcher.views.first.physicalSize.height /
          WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

final mainSystemOverlay = SystemUiOverlayStyle(
  statusBarColor: HexColor.fromHex(kPrimaryColor),
  systemNavigationBarColor: Colors.white,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarDividerColor: Colors.white
);