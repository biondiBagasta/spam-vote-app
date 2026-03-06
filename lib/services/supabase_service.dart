import 'package:akane_vote/models/menu_data.dart';
import 'package:akane_vote/models/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  final supabase = Supabase.instance.client;

  Future<UserData?> login(String username, String password) async {

    final response = await supabase.from("user").select().eq("username", username).eq("password", password).maybeSingle();
   
    return UserData.fromJson(response);
  }

  Future<void> updateUserLoginStatus(String username) async {
    await supabase.from("user").update({
      "is_authenticated": 1
    }).match({
      "username": username
    });
  }

  Future<void> updateUserLoginStatusLogout(String username) async {
    await supabase.from("user").update({
      "is_authenticated": 0
    }).match({
      "username": username
    });
  }

  Future<UserData?> findFirst(String username) async {
    final response = await supabase.from("user").select().eq("username", username).maybeSingle();
    
    return UserData.fromJson(response);
  }

  Future<List<MenuData>> getAllMenu() async {
    final response = await supabase.from("website_data").select();

    return (response as List).map((e) => MenuData.fromJson(e)).toList(); 
  }
}