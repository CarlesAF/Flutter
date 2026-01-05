import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/details_screen.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    this.width = 120,
  });

  final Movie movie;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () => Get.to(
          DetailsScreen(movie: movie),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                Api.imageBaseUrl + movie.posterPath,
                fit: BoxFit.cover,
                height: 130,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xff20252d),
                  ),
                  child: const Icon(
                    Icons.movie,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
                loadingBuilder: (_, __, ___) {
                  if (___ == null) return __;
                  return const FadeShimmer(
                    width: double.infinity,
                    height: 130,
                    highlightColor: Color(0xff22272f),
                    baseColor: Color(0xff20252d),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
