import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/helpers/secure_storage_helper.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'features/auth/data/data_sources/auth_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecase/check_token.dart';
import 'features/auth/domain/usecase/login_with_username_and_password.dart';
import 'features/auth/domain/usecase/logout.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';

// Service locator
GetIt sl = GetIt.instance;

Future<void> initializeLocator() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<Connectivity>(Connectivity());
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //! Core - Helpers
  sl.registerSingleton<SharedPreferencesHelper>(SharedPreferencesHelper(sl()));
  sl.registerSingleton<SecureStorageHelper>(SecureStorageHelper(sl()));

  //! Data source
  sl.registerSingleton<AuthDataSource>(AuthDataSourceImpl(sl()));

  //! Repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));

  //! UseCase
  sl.registerLazySingleton<LoginWithUsernameAndPasswordUC>(() => LoginWithUsernameAndPasswordUC(sl()));
  sl.registerLazySingleton<LogoutUC>(() => LogoutUC(sl()));
  sl.registerLazySingleton<CheckTokenUC>(() => CheckTokenUC(sl()));

  //! Bloc
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl(), sl()));
}

// <https://pub.dev/packages/get_it>