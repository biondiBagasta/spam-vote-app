import "dart:math";

import "package:akane_vote/components/main_text_component.dart";
import "package:akane_vote/cubit/user_cubit.dart";
import "package:akane_vote/locator.dart";
import "package:akane_vote/models/menu_data.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:webview_flutter/webview_flutter.dart";

class WebviewScreen extends StatefulWidget {

  const WebviewScreen({ super.key, required this.menuData });

  final MenuData menuData;

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  final webviewController = WebViewController();

  final genderList = ["Male", "Female"];

  final ageList = ["14 and under", "15-17", "18-21", "26-30", "31+"];

  final random = Random();


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
        
        await _injectClickListener();
        if(widget.menuData.isCouple == 0) {
          await webviewController.runJavaScript("""
            (function() {
              const btn = Array.from(
                document.querySelectorAll('[role="button"], button')
              ).find(el => 
                el.textContent &&
                el.textContent.trim().toLowerCase().includes('next')
              );

              if (btn) {
                btn.click();
              }

              // 2️⃣ Tunggu element tab ke-2 muncul
              const interval = setInterval(() => {
                const el = document.getElementById('${widget.menuData.targetElement}');

                if (el) {
                  

                  clearInterval(interval);

                  setTimeout(() => {
                    el.click();
                    setTimeout(() => {
                      btn.click();
                    }, 300)
                  }, 500);
                }
              }, 500);

              // 3. Cari Element Gender
              const interval2 = setInterval(() => {
                const elGender = document.querySelector('input[name="sex"][value="$randomGender"]');
                const elAge = document.querySelector(`input[name="age"][value="$randomAge"]`);

                if(elGender && elAge) {
                  elGender.click();
                  elAge.click()

                  setTimeout(() => {
                    const btnSubmitVote = Array.from(
                      document.querySelectorAll('[role="button"], button')
                    ).find(el => 
                      el.textContent &&
                      el.textContent.trim().toLowerCase().includes('submit vote')
                    );

                    btnSubmitVote.click()
                  }, 500);

                  // Tunggu submit final muncul
                  const intervalSubmit = setInterval(() => {

                    const btnSubmitFinal = Array.from(
                      document.querySelectorAll('[role="button"], button')
                    ).find(el => {
                      const text = el.textContent?.trim().toLowerCase();
                      return text === 'submit'; // hanya submit final
                    });

                    if(btnSubmitFinal){
                      btnSubmitFinal.click();
                      clearInterval(intervalSubmit);

                      FlutterChannel.postMessage("reload_page");
                    }

                  }, 300);
                }
              }, 300)
            })();
          """);
        } else {
          await webviewController.runJavaScript(
            """
            (function() {
              const el = document.getElementById('${widget.menuData.targetElement}');

              if (el) {
                el.click();

                const btn = Array.from(
                  document.querySelectorAll('[role="button"], button')
                ).find(el => 
                  el.textContent &&
                  el.textContent.trim().toLowerCase().includes('next')
                );

                if (btn) {
                  btn.click();
                }
              }

              // 3. Cari Element Gender
              const interval2 = setInterval(() => {
                const elGender = document.querySelector('input[name="sex"][value="$randomGender"]');
                const elAge = document.querySelector(`input[name="age"][value="$randomAge"]`);

                if(elGender && elAge) {
                  elGender.click();
                  elAge.click()

                  setTimeout(() => {
                    const btnSubmitVote = Array.from(
                      document.querySelectorAll('[role="button"], button')
                    ).find(el => 
                      el.textContent &&
                      el.textContent.trim().toLowerCase().includes('submit vote')
                    );

                    btnSubmitVote.click()
                  }, 500);

                  // Tunggu submit final muncul
                  const intervalSubmit = setInterval(() => {

                    const btnSubmitFinal = Array.from(
                      document.querySelectorAll('[role="button"], button')
                    ).find(el => {
                      const text = el.textContent?.trim().toLowerCase();
                      return text === 'submit'; // hanya submit final
                    });

                    if(btnSubmitFinal){
                      btnSubmitFinal.click();
                      clearInterval(intervalSubmit);

                      setTimeout(() => {
                        FlutterChannel.postMessage("reload_page");
                      }, 500);
                    }

                  }, 300);
                }
              }, 300)
            })();
            """
          );
        }
      },
    ),
  )
  ..loadRequest(Uri.parse(widget.menuData.url!));

    super.initState();
  }

  Future<void> _injectClickListener() async {
    await webviewController.runJavaScript("""
      const ids = [
        '${widget.menuData.blockedElement}',
      ];

      const interval = setInterval(() => {

        ids.forEach(id => {
          const el = document.getElementById(id);

          if (el && !el.__flutterListenerAdded) {
            el.__flutterListenerAdded = true;

            el.addEventListener('click', function() {
              FlutterChannel.postMessage('close_page');
            });
          }
        });

      }, 300);
    """);
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
          title: MainTextComponent(text: "${widget.menuData.name!} (${locator.get<UserCubit>().state.userData.id})", fontSize: 14, fontWeight: FontWeight.w600),
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