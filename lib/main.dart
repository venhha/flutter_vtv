import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_vtv/core/notification/firebase_cloud_messaging_manager.dart';
import 'package:flutter_vtv/firebase_options.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app_state.dart';
import 'config/bloc_config.dart';
import 'config/themes/theme_provider.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'core/notification/local_notification_manager.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'service_locator.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = GlobalBlocObserver(); // NOTE: debug

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeLocator();
  sl<LocalNotificationManager>().init();
  sl<FirebaseCloudMessagingManager>().init();

  final appState = AppState(sl<SharedPreferencesHelper>(), sl<Connectivity>())..init();

  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => appState..subscribeConnection(),
      ),
      BlocProvider(create: (context) => sl<AuthCubit>()..onStarted()),
    ],
    child: const VTVApp(),
  ));
}
