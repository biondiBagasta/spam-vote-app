
import "package:akane_vote/components/main_text_component.dart";
import "package:akane_vote/components/regular_textfield_component.dart";
import "package:akane_vote/components/show_error_snackbar.dart";
import "package:akane_vote/components/show_loading_submit.dart";
import "package:akane_vote/cubit/user_cubit.dart";
import "package:akane_vote/locator.dart";
import "package:akane_vote/services/secure_storage_service.dart";
import "package:akane_vote/services/supabase_service.dart";
import "package:akane_vote/utils/utils.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

class LoginScreen extends StatefulWidget {

  const LoginScreen({ super.key });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    final username = usernameController.text;
    final password = passwordController.text;

    showLoadingSubmit(context, "Proceed to Login...");

    if(username.isEmpty || password.isEmpty) {
      showErrorSnackBar(context, "ERROR", "Username / Password Shouldn't be Empty");
    } else {
      locator.get<SupabaseService>().login(username, password).then((value) {
        if(value == null || value.id == null) {
          if(mounted) {
            context.pop();
            showErrorSnackBar(context, "ERROR", "Wrong Username / Password");
          }
        } else {

          if(value.isAuthenticated == true || value.isBlocked == true) {
            if(value.isAuthenticated == true) {
              if(mounted) {
                context.pop();
                showErrorSnackBar(context, "ERROR", "This Account is already Authenticated.");
              }
            }

            if(value.isBlocked == true) {
              if(mounted) {
                context.pop();
                showErrorSnackBar(context, "ERROR", "This Account was blocked by system.");
              }
            }
          } else {
            locator.get<SupabaseService>().updateUserLoginStatus(username).then((_) {
              locator.get<UserCubit>().updateState(value);
              locator.get<SecureStorageService>().writeSecureData("user", value.username!).then((_) {
                if(mounted) {
                  context.goNamed("home");
                }
              });
            });
          }
          
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex(kBackgroundColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/akane-chibi.jpeg",
                  width: 128,
                ),
              ),
              const SizedBox(height: 12,),
              RegularTextFieldComponent(
                label: "Username", 
                hint: "Username", 
                controller: usernameController, 
                validationMessage: "", 
                prefixIcon: LucideIcons.userRound, 
                isObsecure: false
              ),
              const SizedBox(height: 12,),
              RegularTextFieldComponent(
                label: "Password", 
                hint: "Password", 
                controller: passwordController, 
                validationMessage: "", 
                prefixIcon: LucideIcons.lock, 
                isObsecure: true
              ),
              const SizedBox(height: 18,),
              SizedBox(
                width: constantScreenWidth,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor.fromHex(kPrimaryColor)
                  ),
                  onPressed: () {
                    login();
                  }, 
                  child: MainTextComponent(
                    text: "Login",
                    isWhite: true, 
                    fontSize: 14, 
                    fontWeight: FontWeight.w600,
                  )
                )
              )
            ],
          ),
        )
      ),
    );
  }
}