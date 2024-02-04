import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/helpers/shared_preferences_helper.dart';

class AppState extends ChangeNotifier {
  final SharedPreferencesHelper _prefHelper;
  final Connectivity _connectivity;

  AppState(this._prefHelper, this._connectivity) : _isFirstRun = _prefHelper.isFirstRun;

  bool _isFirstRun;
  late bool hasConnection;

  // initialize the connection
  Future<void> checkConnection() async {
    hasConnection = await _connectivity.checkConnectivity() != ConnectivityResult.none;
  }

  Stream<ConnectivityResult> get connectionStream => _connectivity.onConnectivityChanged;

  // subscribe to the connectivity stream
  void subscribeConnection() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      hasConnection = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  bool get isFirstRun => _isFirstRun;

  /// Sets the app as started.
  Future<void> started() async {
    _isFirstRun = false;
    await _prefHelper.setStarted(false);
    notifyListeners();
  }
}