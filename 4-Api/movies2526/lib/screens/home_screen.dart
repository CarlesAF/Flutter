import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/widgets/actor_item.dart';
import 'package:movies/widgets/movie_item.dart';
import 'package:movies/widgets/actor_card.dart';
import 'package:movies/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MoviesController controller = Get.put(MoviesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  var selectedMenu = 0.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 42, right: 24),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => selectedMenu.value == 0
                    ? _buildActorsTab()
                    : _buildMoviesSeriesTab(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[700],
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              title: const Text(
                'Actors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                selectedMenu.value = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              title: const Text(
                'Movies & Series',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                selectedMenu.value = 1;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActorsTab() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          controller.loadMoreTrendingActors();
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular Actors',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 310,
                      child: controller.popularActors.isEmpty
                          ? const Center(
                              child: Text('No actors found'),
                            )
                          : ListView.separated(
                              itemCount: controller.popularActors.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 24),
                              itemBuilder: (_, index) => ActorItem(
                                  actor: controller.popularActors[index],
                                  index: index + 1),
                            ),
                    )),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending This Week',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : controller.trendingActors.isEmpty
                      ? const Center(
                          child: Text('No trending actors'),
                        )
                      : GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.63,
                            ),
                            itemCount: controller.trendingActors.length,
                            itemBuilder: (_, index) => ActorCard(
                              actor: controller.trendingActors[index],
                            ),
                          )),
            ),
            Obx(
              () => controller.isLoadingMore.value
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesSeriesTab() {
    return Column(
      children: [
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
              Tab(text: 'Movies'),
              Tab(text: 'Series'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMoviesContent(),
              _buildSeriesContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoviesContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          controller.loadMoreTrendingMovies();
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular Movies',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 310,
                      child: controller.mainTopRatedMovies.isEmpty
                          ? const Center(
                              child: Text('No movies found'),
                            )
                          : ListView.separated(
                              itemCount: controller.mainTopRatedMovies.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 24),
                              itemBuilder: (_, index) => MovieItem(
                                  movie: controller.mainTopRatedMovies[index],
                                  index: index + 1),
                            ),
                    )),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending Movies This Week',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : controller.trendingMovies.isEmpty
                      ? const Center(
                          child: Text('No trending movies'),
                        )
                      : GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.63,
                            ),
                            itemCount: controller.trendingMovies.length,
                            itemBuilder: (_, index) => MovieCard(
                              movie: controller.trendingMovies[index],
                            ),
                          )),
            ),
            Obx(
              () => controller.isLoadingMore.value
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesContent() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          controller.loadMoreTrendingSeries();
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular Series',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 310,
                      child: controller.mainTopRatedSeries.isEmpty
                          ? const Center(
                              child: Text('No series found'),
                            )
                          : ListView.separated(
                              itemCount: controller.mainTopRatedSeries.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 24),
                              itemBuilder: (_, index) => MovieItem(
                                  movie: controller.mainTopRatedSeries[index],
                                  index: index + 1),
                            ),
                    )),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending Series This Week',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : controller.trendingSeries.isEmpty
                      ? const Center(
                          child: Text('No trending series'),
                        )
                      : GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.63,
                            ),
                            itemCount: controller.trendingSeries.length,
                            itemBuilder: (_, index) => MovieCard(
                              movie: controller.trendingSeries[index],
                            ),
                          )),
            ),
            Obx(
              () => controller.isLoadingMore.value
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
