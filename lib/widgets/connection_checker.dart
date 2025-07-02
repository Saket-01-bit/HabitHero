import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionChecker extends StatefulWidget {
  final Widget child;
  const ConnectionChecker({super.key, required this.child});

  @override
  State<ConnectionChecker> createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isDisconnected = false;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final connected = result != ConnectivityResult.none;
      if (!connected && !_isDisconnected) {
        _isDisconnected = true;
        Get.toNamed('/no-internet');
      } else if (connected && _isDisconnected) {
        _isDisconnected = false;
        if (Get.currentRoute == '/no-internet') {
          Get.offAllNamed('/home'); // or restore previous screen
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
