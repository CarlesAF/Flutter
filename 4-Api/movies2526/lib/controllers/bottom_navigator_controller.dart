import 'package:get/get.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:movies/screens/search_screen.dart';
import 'package:movies/screens/watch_list_screen.dart';

class BottomNavigatorController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Get.put(SearchController1());
  }

  var screens = [
    HomeScreen(),
    const SearchScreen(),
    const WatchList(),
  ];
  var index = 0.obs;
  void setIndex(indx) => index.value = indx;
}
