import "package:akane_vote/components/curve_clipper.dart";
import "package:akane_vote/components/main_text_component.dart";
import "package:akane_vote/components/primary_only_appbar.dart";
import "package:akane_vote/components/show_error_snackbar.dart";
import "package:akane_vote/cubit/user_cubit.dart";
import "package:akane_vote/locator.dart";
import "package:akane_vote/models/menu_data.dart";
import "package:akane_vote/services/secure_storage_service.dart";
import "package:akane_vote/services/supabase_service.dart";
import "package:akane_vote/utils/utils.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

class HomeScreen extends StatefulWidget {

  const HomeScreen({ super.key });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
     locator.get<SecureStorageService>().readSecureData("user").then((value) {
      if(value == null) {
        if(mounted) {
          context.goNamed("login");
        }
      } else {
        locator.get<SupabaseService>().findFirst(value).then((value2) {
          if(value2 == null) {
            locator.get<SecureStorageService>().deleteAllSecureData();
            if(mounted) {
              context.goNamed("login");
            }
          } else {
            if(value2.isBlocked == true) {
              locator.get<SecureStorageService>().deleteAllSecureData();
              if(mounted) {
                showErrorSnackBar(context, "ERROR", "Your Account Has Been Blocked");
                context.goNamed("login");
              }
            } else {
              locator.get<UserCubit>().updateState(value2);
            }
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryOnlyAppbar(),
      backgroundColor: HexColor.fromHex(kBackgroundColor),
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                width: constantScreenWidth,
                height: 230,
                decoration: BoxDecoration(
                  color: HexColor.fromHex(kPrimaryColor)
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 28,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: HexColor.fromHex(kPrimaryColor),
                            child: Icon(LucideIcons.user500, size: 28, color: Colors.white,),
                          ),
                        ),
                        const SizedBox(width: 12,),
                        BlocBuilder<UserCubit, UserState>(
                          bloc: locator.get<UserCubit>(),
                          builder: (_, state) {
                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MainTextComponent(text: "Welcome", fontSize: 14, fontWeight: FontWeight.w500, isWhite: true,),
                                  SizedBox(height: 6,),
                                  MainTextComponent(text: state.userData.username!, fontSize: 16, fontWeight: FontWeight.w700, isWhite: true,),
                                ],
                              )
                            );
                          }
                        ),
                      ],
                    ),
                    SizedBox(height: 64,),
                    Card(
                      color: Colors.white,
                      child: SizedBox(
                        width: constantScreenWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.smartphone),
                                  const SizedBox(width: 12,),
                                  Expanded(
                                    child: MainTextComponent(
                                      maxLines: 10,
                                      text: "Remember This Vote will Automatically Choose Akane and Aqua x Akane, so u don't waste your time so much.", 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.smartphone),
                                  const SizedBox(width: 12,),
                                  Expanded(
                                    child: MainTextComponent(
                                      maxLines: 10,
                                      text: "Remember This Vote doesn't work if you're Running the App on the Backround aka If you're Minimizing your App.", 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              Container(
                                padding: const EdgeInsets.all(12),
                                color: Colors.lightBlue.withValues(alpha: 0.5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.smartphone),
                                    const SizedBox(width: 12,),
                                    Expanded(
                                      child: MainTextComponent(
                                        maxLines: 10,
                                        text: "This Method Below is alternative method if Anime Trending is really tracking your IP.", 
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.smartphone),
                                  const SizedBox(width: 12,),
                                  Expanded(
                                    child: MainTextComponent(
                                      maxLines: 10,
                                      text: "Remember if you're using ISP Mobile Data, After you're already voting, Activate Your Flight Mode and Deactive it again, so your IP will be randomize again, so Anime Trending can't track it.", 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.info),
                                  const SizedBox(width: 12,),
                                  Expanded(
                                    child: MainTextComponent(
                                      maxLines: 10,
                                      text: "Use the method Above after you're done for voting both Akane and Aqua x Akane!!!", 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.info),
                                  const SizedBox(width: 12,),
                                  Expanded(
                                    child: MainTextComponent(
                                      maxLines: 10,
                                      text: "Remember to close browser page, click the back button (Arrow Left Icon) on the top corner left, u can't use ur phone button!!!", 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18,),
                    FutureBuilder<List<MenuData>>(
                      future: locator.get<SupabaseService>().getAllMenu(), 
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return Card(
                            color: Colors.white,
                            surfaceTintColor: HexColor.fromHex(kPrimaryColor),
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final dataList = snapshot.data!;
                                
                                    // 👉 Jika index terakhir (item tambahan)
                                    if (index == dataList.length) {
                                      return ListTile(
                                        onTap: () {
                                          context.pushNamed("anime-corner");
                                        },
                                        leading: Icon(LucideIcons.flower, color: Colors.red,),
                                        title: MainTextComponent(
                                          text: "Vote for Anime Corner",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        trailing: Icon(LucideIcons.chevronRight),
                                      );
                                    }

                                    if (index == dataList.length + 1) {
                                      return ListTile(
                                        onTap: () {
                                          locator.get<SupabaseService>().updateUserLoginStatusLogout(
                                            locator.get<UserCubit>().state.userData.username!
                                          ).then((_) {
                                            locator.get<SecureStorageService>().deleteAllSecureData().then((_) {
                                              if(context.mounted) {
                                                context.goNamed("login");
                                              }
                                            });
                                          });
                                        },
                                        leading: Icon(LucideIcons.logOut),
                                        title: MainTextComponent(
                                          text: "Logout",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        trailing: Icon(LucideIcons.chevronRight),
                                      );
                                    }
                                
                                    // 👉 Item normal dari database
                                    final item = dataList[index];
                                
                                    return ListTile(
                                      onTap: () {
                                        context.pushNamed("webview", extra: {
                                          "menuData": snapshot.data![index]
                                        });
                                      },
                                      leading: Icon(
                                        item.isCouple == true
                                            ? LucideIcons.heart600
                                            : LucideIcons.user,
                                      ),
                                      title: MainTextComponent(
                                        text: item.name ?? "",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      trailing: Icon(LucideIcons.chevronRight),
                                    );
                                  }, 
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  }, 
                                  itemCount: snapshot.data!.length + 2
                                ),
                              ],
                            )
                          );
                        } else {
                          return const SizedBox();
                        }
                      }
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}