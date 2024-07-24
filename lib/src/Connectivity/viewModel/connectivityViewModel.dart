import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class connectivityViewModel extends ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;
  connectivityViewModel() {
    initialize();
  }

  void initialize() async {
    final connectivity = Connectivity();
    var result = await connectivity.checkConnectivity();
    updateConnectionStatus(result);

    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      updateConnectionStatus(result);
    });
  }

  void updateConnectionStatus(ConnectivityResult result) {
    final isConnected = result != ConnectivityResult.none;
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    }
  }
  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();
  }
  Future<void> retryConnection() async {
    await checkConnectivity();
  }
}
class NetworkStatusDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<connectivityViewModel>(
      builder: (context, connectivityService, child) {
        if (connectivityService.isConnected) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!connectivityService.isConnected) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('No Internet Connection'),
                  content: Text('Please connect to a network.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        await connectivityService.retryConnection();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                );
              },
            );
          }
        });

        return SizedBox.shrink(); // The widget itself doesn't render anything
      },
    );
  }
}