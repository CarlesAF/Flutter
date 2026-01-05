import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/screens/actor_detail_screen.dart';
import 'package:movies/widgets/index_number.dart';

class ActorItem extends StatelessWidget {
  const ActorItem({
    super.key,
    required this.actor,
    required this.index,
  });

  final Actor actor;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Get.to(
            ActorDetailScreen(actor: actor),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    Api.imageBaseUrl + actor.profilePath,
                    fit: BoxFit.cover,
                    height: 220,
                    width: 160,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xff20252d),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                    loadingBuilder: (_, __, ___) {
                      if (___ == null) return __;
                      return const FadeShimmer(
                        width: 160,
                        height: 220,
                        highlightColor: Color(0xff22272f),
                        baseColor: Color(0xff20252d),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 160,
                  child: Text(
                    actor.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IndexNumber(number: index),
        )
      ],
    );
  }
}
