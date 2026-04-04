import "dart:math";

import "package:akane_vote/components/main_text_component.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:webview_flutter/webview_flutter.dart";

class AnimeCornerScreen extends StatefulWidget {

  const AnimeCornerScreen({ super.key });


  @override
  State<AnimeCornerScreen> createState() => _AnimeCornerScreenState();
}

class _AnimeCornerScreenState extends State<AnimeCornerScreen> {
  final webviewController = WebViewController();

  final ageList = ["12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22",
    "23", "24", "25", "26", "27", "28", "29", "30", "31"
  ];

  final genderList = ["M", "F", "O"];

  final random = Random();

  final urlVote = "https://polls.animecorner.me/group/vote/aots-winter2026";

  final femaleCharacterTitle = "Best Female Character";
  final coupleTitle = "Best Ship or Couple";
  final akaneCharacterTitle = "Akane Kurokawa";
  final aquaAkaneCharacterTitle = "Aqua Hoshino x Akane Kurokawa";

  @override
  void initState() {
    webviewController.clearCache();
    webviewController.clearLocalStorage();
    webviewController
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..addJavaScriptChannel(
    'FlutterChannel',
    onMessageReceived: (JavaScriptMessage message) {
      if (message.message == 'close_page') {
        Navigator.of(context).pop();
      }

      if (message.message == 'reload_page') {
        Future.delayed(const Duration(milliseconds: 1000)).then((_) async {
          webviewController.reload();

          final cookieManager = WebViewCookieManager();

          await cookieManager.clearCookies();

          await webviewController.runJavaScript("""
            localStorage.clear();
            sessionStorage.clear();
            indexedDB.databases().then(dbs => {
              dbs.forEach(db => indexedDB.deleteDatabase(db.name));
            });
          """);
        });
      }
    },
  )
  ..setNavigationDelegate(
    NavigationDelegate(
      onPageFinished: (url) async {
        final randomAge = ageList[random.nextInt(ageList.length)];
        final randomGender = genderList[random.nextInt(genderList.length)];

        await webviewController.runJavaScript("""
          (function() {

            // 1 Female Element
            const femaleElement = document.querySelector('[data-title="$femaleCharacterTitle"]');

            if(femaleElement) {
              femaleElement.click();
            }

            // ⏱️ Tunggu 500ms dulu
            setTimeout(() => {
              // 2️⃣ Tunggu element Akane Muncul
              const interval = setInterval(() => {
                const el = document.querySelector('[data-title="$akaneCharacterTitle"]');
                
                if (el) {
                  clearInterval(interval);
                  el.click();
                }
              }, 100);
            }, 500);

            // ⏱️3 Tunggu 500ms dulu
            setTimeout(() => {
              // 3 Tunggu element Couple
              const interval = setInterval(() => {
                const el = document.querySelector('[data-title="$coupleTitle"]');
                
                if (el) {
                  clearInterval(interval);
                  el.click();
                }
              }, 100);
            }, 500);

            // ⏱️4 Tunggu 500ms dulu
            setTimeout(() => {
              // 4 Aqua x Akane Element
              const interval = setInterval(() => {
                const el = document.querySelector('[data-title="$aquaAkaneCharacterTitle"]');
                
                if (el) {
                  clearInterval(interval);
                  el.click();
                }
              }, 100);
            }, 500);

            // ⏱️5 Tunggu 500ms dulu
            setTimeout(() => {
              const interval = setInterval(() => {
                const el = document.getElementById('user_gender');
                
                if (el && el.options.length > 0) {
                  clearInterval(interval);

                  const randomGender = '$randomGender';

                  el.value = randomGender;

                  el.dispatchEvent(new Event('input', { bubbles: true }));
                  el.dispatchEvent(new Event('change', { bubbles: true }));

                }
              }, 100);
            }, 1000);

            // ⏱️6 Tunggu 500ms dulu
            setTimeout(() => {
              // 6 Select Age
              const interval = setInterval(() => {
                const el = document.getElementById('user_age');
                
                if (el) {
                  clearInterval(interval);

                  el.value = '$randomAge';

                  // Trigger event change
                  el.dispatchEvent(new Event('change', { bubbles: true }));
                }
              }, 100);
            }, 1000);

            // ⏱️7 Tunggu 500ms dulu
            setTimeout(() => {
              // 7 Submit BTN
              const interval = setInterval(() => {
                const el = document.getElementById('submit-btn');
                
                if (el) {
                  clearInterval(interval);

                  

                  setTimeout(() => {
                    el.click();
                    setTimeout(() => {
                      FlutterChannel.postMessage("reload_page");
                    }, 1000)
                  }, 1000);
                }
              }, 100);
            }, 1000);
          })();
        """);
      },
    ),
  )
  ..loadRequest(Uri.parse(urlVote));

    super.initState();
  }

  // Future<void> _clearSession() async {
  //   final cookieManager = WebViewCookieManager();
  //   await cookieManager.clearCookies();
  //   await webviewController.clearCache();
  // }

  @override
  void dispose() {
    webviewController.clearCache();
    webviewController.clearLocalStorage();
    final cookieManager = WebViewCookieManager();

    cookieManager.clearCookies();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          centerTitle: true,
          title: MainTextComponent(text: "Anime Corner Vote", fontSize: 14, fontWeight: FontWeight.w600),
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(LucideIcons.arrowLeft),
                const SizedBox(width: 4,),
                Text("Close", style: GoogleFonts.openSans(),)
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: WebViewWidget(controller: webviewController)
        ),
      )
    );
  }
}