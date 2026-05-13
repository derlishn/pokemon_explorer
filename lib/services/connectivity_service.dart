import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find();

  final Connectivity _connectivity = Connectivity();
  final _isConnected = true.obs;
  bool get isConnected => _isConnected.value;
  RxBool get isConnectedRx => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<ConnectivityService> init() async {
    // Check initial status
    final result = await _connectivity.checkConnectivity();
    _updateState(result);

    // Listen to changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateState);
    
    return this;
  }

  void _updateState(List<ConnectivityResult> results) {
    // In connectivity_plus 6.0.0+, it returns a list. 
    // We are connected if any of the results is NOT 'none'.
    final connected = results.any((result) => result != ConnectivityResult.none);
    
    if (_isConnected.value != connected) {
      _isConnected.value = connected;
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
