import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  const PopularView({super.key});

  @override
  createState() => _PopularViewState();
}

class _PopularViewState extends ConsumerState<PopularView> with AutomaticKeepAliveClientMixin{

 @override
  void initState() {
    super.initState();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final popularMovies = ref.watch(popularMoviesProvider);

    if ( popularMovies.isEmpty ) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2,),);
    }

    return MovieMasonry(
      movies: popularMovies, 
      loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
      );
      
  }
  
  @override
  bool get wantKeepAlive => true;
}