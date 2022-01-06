import 'package:get/get.dart';

class StatusController extends GetxController {
  var status = 'Opened'.obs;
  checkStatus(String value) {
    status.value = value;
  }
}
