import 'package:get/get.dart';

class IbfloatingBtnController extends GetxController{
  RxBool isFloatingBtnVisible = false.obs;

  void show(){
    // ignore update if its already visible
    if(isFloatingBtnVisible.value == true) return;
    isFloatingBtnVisible.value = true;
  }

  void hide(){
    // ignore update if its alrady not visible
    if(isFloatingBtnVisible.value == false) return;
    isFloatingBtnVisible.value = false;
  }
}