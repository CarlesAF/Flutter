import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/actor_detail.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/models/movie.dart';

class ActorDetailScreen extends StatelessWidget {
  const ActorDetailScreen({
    super.key,
    required this.actor,
  });

  final Actor actor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<ActorDetail?>(
          future: ApiService.getActorDetail(actor.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null) {
              return const Center(
                child: Text('Error loading actor details'),
              );
            }

            final actorDetail = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          tooltip: 'Back',
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Actor Detail',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Profile Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      Api.imageBaseUrl + actorDetail.profilePath,
                      width: 200,
                      height: 280,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 200,
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xff20252d),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                      loadingBuilder: (_, __, ___) {
                        if (___ == null) return __;
                        return const FadeShimmer(
                          width: 200,
                          height: 280,
                          highlightColor: Color(0xff22272f),
                          baseColor: Color(0xff20252d),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Actor Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      actorDetail.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Popularity
                  Text(
                    'Popularity: ${actorDetail.popularity.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Birthday and Place of Birth
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (actorDetail.birthday != 'Unknown')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Birthday: ${actorDetail.birthday}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        if (actorDetail.placeOfBirth != 'Unknown')
                          Text(
                            'Place of Birth: ${actorDetail.placeOfBirth}',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Biography
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Biography',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          actorDetail.biography,
                          style: const TextStyle(fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Filmography
                  if (actorDetail.filmography.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filmography',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: actorDetail.filmography.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (_, index) {
                              final movie = actorDetail.filmography[index];
                              // Convert MovieInCast to Movie for navigation
                              final movieObj = Movie(
                                id: movie.id,
                                title: movie.title,
                                posterPath: movie.posterPath,
                                backdropPath: '',
                                overview: '',
                                releaseDate: movie.releaseDate,
                                voteAverage: movie.voteAverage,
                                genreIds: [],
                              );
                              return GestureDetector(
                                onTap: () => Get.to(DetailsScreen(movie: movieObj)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        Api.imageBaseUrl + movie.posterPath,
                                        width: 60,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 60,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: const Color(0xff20252d),
                                          ),
                                          child: const Icon(
                                            Icons.image,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'As: ${movie.character}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  size: 14, color: Colors.amber),
                                              const SizedBox(width: 4),
                                              Text(
                                                movie.voteAverage
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
