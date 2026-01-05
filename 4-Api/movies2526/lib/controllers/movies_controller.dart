import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';

class MoviesController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var mainTopRatedMovies = <Movie>[].obs;
  var popularActors = <Actor>[].obs;
  var trendingActors = <Actor>[].obs;
  var trendingMovies = <Movie>[].obs;
  var mainTopRatedSeries = <Movie>[].obs;
  var trendingSeries = <Movie>[].obs;
  var watchListMovies = <Movie>[].obs;
  var currentTrendingPage = 1;
  var currentMoviePage = 1;
  var currentSeriesPage = 1;
  
  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      final topRated = await ApiService.getTopRatedMovies();
      final popular = await ApiService.getPopularActors();
      final trending = await ApiService.getTrendingActors(currentTrendingPage);
      final trendingMovieList = await ApiService.getCustomMovies('popular?api_key=${Api.apiKey}&language=en-US&page=$currentMoviePage');
      final topRatedSeries = await ApiService.getTopRatedSeries();
      final trendingSeriesList = await ApiService.getPopularSeries(currentSeriesPage);
      
      mainTopRatedMovies.value = topRated ?? [];
      popularActors.value = popular ?? [];
      trendingActors.value = trending ?? [];
      trendingMovies.value = trendingMovieList ?? [];
      mainTopRatedSeries.value = topRatedSeries ?? [];
      trendingSeries.value = trendingSeriesList ?? [];
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreTrendingActors() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    currentTrendingPage++;
    final newActors = await ApiService.getTrendingActors(currentTrendingPage);
    if (newActors != null) {
      trendingActors.addAll(newActors);
    }
    isLoadingMore.value = false;
  }

  Future<void> loadMoreTrendingMovies() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    currentMoviePage++;
    final newMovies = await ApiService.getCustomMovies('popular?api_key=${Api.apiKey}&language=en-US&page=$currentMoviePage');
    if (newMovies != null) {
      trendingMovies.addAll(newMovies);
    }
    isLoadingMore.value = false;
  }

  Future<void> loadMoreTrendingSeries() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;
    currentSeriesPage++;
    final newSeries = await ApiService.getPopularSeries(currentSeriesPage);
    if (newSeries != null) {
      trendingSeries.addAll(newSeries);
    }
    isLoadingMore.value = false;
  }

  bool isInWatchList(Movie movie) {
    return watchListMovies.any((m) => m.id == movie.id);
  }

  void addToWatchList(Movie movie) {
    if (watchListMovies.any((m) => m.id == movie.id)) {
      watchListMovies.remove(movie);
      Get.snackbar(
        'Removed from Watch List',
        movie.title,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1F1F1F),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        titleText: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Removed from Watch List',
            style: const TextStyle(
              color: Color(0xFFFFA726),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        messageText: Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        icon: const Icon(
          Icons.bookmark_remove,
          color: Color(0xFFFFA726),
          size: 28,
        ),
      );
    } else {
      watchListMovies.add(movie);
      Get.snackbar(
        'Added to Watch List',
        movie.title,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1F1F1F),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        titleText: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Added to Watch List',
            style: const TextStyle(
              color: Color(0xFF0296E5),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        messageText: Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        icon: const Icon(
          Icons.bookmark_add,
          color: Color(0xFF0296E5),
          size: 28,
        ),
      );
    }
  }
}
