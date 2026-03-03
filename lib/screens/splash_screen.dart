import "package:akane_vote/locator.dart";
import "package:akane_vote/services/secure_storage_service.dart";
import "package:another_flutter_splash_screen/another_flutter_splash_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class SplashScreen extends StatefulWidget {

  const SplashScreen({ super.key });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {

    return FlutterSplashScreen.fadeIn(
      useImmersiveMode: false,
      
      backgroundColor: Colors.white,
      childWidget: Center(
        child: Image.asset("assets/akane-chibi2.jpg",)
      ),
      asyncNavigationCallback: () async {
        Future.delayed(const Duration(seconds: 2)).then((_) {
          checkAlreadyAuthenticated();
        });
      },
    );
  }

  void checkAlreadyAuthenticated() {
    locator.get<SecureStorageService>().readSecureData("user").then((value) {
      if(value == null) {
        if(mounted) {
          context.goNamed("login");
        }
      } else {
        if(mounted) {
          context.goNamed("home");
        }
      }
    });
  }
}