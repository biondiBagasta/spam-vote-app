import 'package:akane_vote/components/main_text_component.dart';
import 'package:akane_vote/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showLoadingSubmit(BuildContext context, String label) {
  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (context) {
      return LayoutBuilder(
        builder: (context, constrains) {
          final screenWidth = constrains.maxWidth;
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white
              ),
              width: screenWidth * 0.8,
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: HexColor.fromHex(kPrimaryColor).withValues(alpha:  0.4),
                    child: SpinKitFadingCircle(
                      size: 50,
                      color: HexColor.fromHex(kPrimaryColor),
                    ),
                  ),
                  const SizedBox(height: 18,),
                  Material(
                    child: MainTextComponent(text: label, fontSize: 16, fontWeight: FontWeight.w600, textAlign: TextAlign.center,),
                  )
                ],
              ),
            ),
          );
        }
      );
    }
  );
}