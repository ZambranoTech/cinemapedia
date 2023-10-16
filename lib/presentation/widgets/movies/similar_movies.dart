import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProviderFamily<List<Movie>, int> similarMoviesProvider = FutureProviderFamily((ref, int id) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getSimilarMovies(id);
});


class SimilarMovies extends ConsumerStatefulWidget {
  
  final int movieId;

  const SimilarMovies({super.key, required this.movieId});

  @override
  createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends ConsumerState<SimilarMovies> {
  @override
  Widget build(BuildContext context) {

    final similarMovies = ref.watch(similarMoviesProvider(widget.movieId));

    return similarMovies.when(
      data: (similarMovies) => _Recomendations(movies: similarMovies), 
      error: (_, __ ) => const Center(child: Text('No se pudieron cargar las películas similares'),), 
      loading: () => const CircularProgressIndicator(strokeWidth: 2,));



  }
}

class _Recomendations extends StatelessWidget {
  final List<Movie> movies;

  const _Recomendations({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 50, top: 20),
      child: MovieHorizontalListview(movies: movies, title: 'Recomendaciones')
      );
  }
}