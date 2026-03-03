import 'package:akane_vote/cubit/user_cubit.dart';
import 'package:akane_vote/services/secure_storage_service.dart';
import 'package:akane_vote/services/supabase_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(UserCubit());
  // Lazy
  locator.registerLazySingleton(() => SecureStorageService());
  locator.registerLazySingleton(() => SupabaseService());
}

void closeLocator() {
  locator.get<UserCubit>().close();
}