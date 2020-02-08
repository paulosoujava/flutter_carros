import 'package:connectivity/connectivity.dart';

Future<bool> isNetwork() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}
