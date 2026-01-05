import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';

class SearchController1 extends GetxController {
  TextEditingController searchController = TextEditingController();
  var searchText = ''.obs;
  var foundedMovies = <Movie>[].obs;
  var foundedActors = <Actor>[].obs;
  var foundedSeries = <Movie>[].obs;
  var isLoading = false.obs;
  var hasSearched = false.obs;
  void setSearchText(text) => searchText.value = text;
  void search(String query) async {
    isLoading.value = true;
    hasSearched.value = true;
    foundedMovies.value = (await ApiService.getSearchedMovies(query)) ?? [];
    foundedActors.value = (await ApiService.getSearchedActors(query)) ?? [];
    foundedSeries.value = (await ApiService.getSearchedSeries(query)) ?? [];
    isLoading.value = false;
  }
}
