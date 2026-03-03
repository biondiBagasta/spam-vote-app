import "package:akane_vote/components/main_text_component.dart";
import "package:akane_vote/models/menu_data.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
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

  bool hasClicked = false;

  @override
  void initState() {
    webviewController
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..addJavaScriptChannel(
    'FlutterChannel',
    onMessageReceived: (JavaScriptMessage message) {
      if (message.message == 'close_page') {
        Navigator.of(context).pop();
      }
    },
  )
  ..setNavigationDelegate(
    NavigationDelegate(
      onPageFinished: (url) async {
        await _injectClickListener();
        if(widget.menuData.isCouple == false) {
          if(hasClicked) return;

          hasClicked = true;

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
                  el.click();

                  const rect = el.getBoundingClientRect();
                  window.scrollTo({
                    top: rect.top + window.scrollY - 100
                  });

                  clearInterval(interval);

                  setTimeout(() => {
                    btn.click();
                  }, 1000);
                }
              }, 300);
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
          title: MainTextComponent(text: widget.menuData.name!, fontSize: 14, fontWeight: FontWeight.w600),
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Icon(LucideIcons.arrowLeft),
          ),
        ),
        body: SafeArea(
          child: WebViewWidget(controller: webviewController)
        ),
      )
    );
  }
}