import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieRating extends StatelessWidget {
  
  final Movie movie;

  const MovieRating({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;


    return SizedBox(
      width: 150,
      child: Row(
        children: [
          Icon(
            Icons.star_half_outlined,
            color: Colors.yellow.shade800,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(HumanFormats.number(movie.voteAverage, 1),
              style: textStyles.bodyMedium
                  ?.copyWith(color: Colors.yellow.shade800)),
        ],
      ),
    );
  }
}
