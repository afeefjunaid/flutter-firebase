import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class connectivityViewModel extends ChangeNotifier {
  bool isConnected = false;

  initialize() async {
    final connectivity = Connectivity();
    var result = await connectivity.checkConnectivity();
    updateConnectionStatus(result);
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      updateConnectionStatus(result);
    });

  }

  void updateConnectionStatus(ConnectivityResult result) {
    final _isConnected = result != ConnectivityResult.none;
    if (isConnected != _isConnected) {
      isConnected = _isConnected;
      notifyListeners();
    }
  }

  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    updateConnectionStatus(result);
  }
}
