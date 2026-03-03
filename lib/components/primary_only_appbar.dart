import "package:akane_vote/utils/utils.dart";
import "package:flutter/material.dart";

class PrimaryOnlyAppbar extends StatelessWidget implements PreferredSizeWidget {

  const PrimaryOnlyAppbar({ super.key });


  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: mainSystemOverlay,
      backgroundColor: HexColor.fromHex(kPrimaryColor),
      centerTitle: true,
      toolbarHeight: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}