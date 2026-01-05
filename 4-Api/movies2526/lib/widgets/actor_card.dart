import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/screens/actor_detail_screen.dart';

class ActorCard extends StatelessWidget {
  const ActorCard({
    super.key,
    required this.actor,
  });

  final Actor actor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        ActorDetailScreen(actor: actor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              Api.imageBaseUrl + actor.profilePath,
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
                  Icons.person,
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
              actor.name,
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
    );
  }
}
