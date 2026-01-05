import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/screens/actor_detail_screen.dart';
import 'package:movies/widgets/infos.dart';
import 'package:movies/widgets/search_box.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242A32),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Back to home',
                    onPressed: () =>
                        Get.find<BottomNavigatorController>().setIndex(0),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                  ),
                  const Tooltip(
                    message: 'Search for movies, series, or actors here!',
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchBox(
                onSumbit: () {
                  String search =
                      Get.find<SearchController1>().searchController.text;
                  Get.find<SearchController1>().searchController.text = '';
                  Get.find<SearchController1>().search(search);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            const SizedBox(height: 24),
            // TabBar
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF0296E5),
                    width: 2,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF0296E5),
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color(0xFF0296E5),
                unselectedLabelColor: const Color(0xFF67686D),
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Actors'),
                  Tab(text: 'Movies'),
                  Tab(text: 'Series'),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Obx(
                () => Get.find<SearchController1>().isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Get.find<SearchController1>().hasSearched.value == false
                        ? Center(
                            child: SizedBox(
                              width: Get.width / 1.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/no.svg',
                                    height: 120,
                                    width: 120,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Search your favorite content',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Opacity(
                                    opacity: .7,
                                    child: Text(
                                      'Find movies, series, or actors by name',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              // Actors Tab
                              _buildActorsTab(),
                              // Movies Tab
                              _buildMoviesTab(),
                              // Series Tab
                              _buildSeriesTab(),
                            ],
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActorsTab() {
    return Obx(
      () {
        if (Get.find<SearchController1>().foundedActors.isEmpty) {
          return Center(
            child: SizedBox(
              width: Get.width / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/no.svg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'No Actors Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Opacity(
                    opacity: .7,
                    child: Text(
                      'Try searching for your favorite actor',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: Get.find<SearchController1>().foundedActors.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            Actor actor = Get.find<SearchController1>().foundedActors[index];
            return GestureDetector(
              onTap: () => Get.to(ActorDetailScreen(actor: actor)),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff20252d),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        Api.imageBaseUrl + actor.profilePath,
                        height: 100,
                        width: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xff2f3541),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                        loadingBuilder: (_, __, ___) {
                          if (___ == null) return __;
                          return const FadeShimmer(
                            width: 75,
                            height: 100,
                            highlightColor: Color(0xff22272f),
                            baseColor: Color(0xff20252d),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actor.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            actor.knownForDepartment,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMoviesTab() {
    return Obx(
      () {
        if (Get.find<SearchController1>().foundedMovies.isEmpty) {
          return Center(
            child: SizedBox(
              width: Get.width / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/no.svg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'No Movies Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Opacity(
                    opacity: .7,
                    child: Text(
                      'Try searching for your favorite movie',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: Get.find<SearchController1>().foundedMovies.length,
          separatorBuilder: (_, __) => const SizedBox(height: 24),
          itemBuilder: (_, index) {
            Movie movie = Get.find<SearchController1>().foundedMovies[index];
            return GestureDetector(
              onTap: () => Get.to(DetailsScreen(movie: movie)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      Api.imageBaseUrl + movie.posterPath,
                      height: 180,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        size: 120,
                      ),
                      loadingBuilder: (_, __, ___) {
                        if (___ == null) return __;
                        return const FadeShimmer(
                          width: 120,
                          height: 180,
                          highlightColor: Color(0xff22272f),
                          baseColor: Color(0xff20252d),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Infos(movie: movie)
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSeriesTab() {
    return Obx(
      () {
        if (Get.find<SearchController1>().foundedSeries.isEmpty) {
          return Center(
            child: SizedBox(
              width: Get.width / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/no.svg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'No Series Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Opacity(
                    opacity: .7,
                    child: Text(
                      'Try searching for your favorite series',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: Get.find<SearchController1>().foundedSeries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 24),
          itemBuilder: (_, index) {
            Movie serie = Get.find<SearchController1>().foundedSeries[index];
            return GestureDetector(
              onTap: () => Get.to(DetailsScreen(movie: serie)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      Api.imageBaseUrl + serie.posterPath,
                      height: 180,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        size: 120,
                      ),
                      loadingBuilder: (_, __, ___) {
                        if (___ == null) return __;
                        return const FadeShimmer(
                          width: 120,
                          height: 180,
                          highlightColor: Color(0xff22272f),
                          baseColor: Color(0xff20252d),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Infos(movie: serie)
                ],
              ),
            );
          },
        );
      },
    );
  }
}

