import 'package:connectivity/connectivity.dart';

class UtilHelperMethods {
  static Future<bool> isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
