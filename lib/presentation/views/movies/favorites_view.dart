import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  void loadNextPage() async {

    if ( isLoading || isLastPage) return;

    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;


    if ( movies.isEmpty ) {
      isLastPage = true;
    }


  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoritesMovies.isEmpty) {
      return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, color: colors.primary, size: 60,),
          Text('Ohhh no!!', style: TextStyle( color: colors.primary, fontSize: 30 ),),
          Text('No tienes peliculas favoritas', style: TextStyle(color: colors.secondary, fontSize: 20),),

          const SizedBox(height: 20,),
          FilledButton.tonal(
            onPressed: () => context.go('/home/0'), 
            child: const Text('Empieza a buscar')
          )
        ],
      ),

    );
    }

    return Scaffold(
      body: MovieMasonry(
        loadNextPage: loadNextPage,
        movies: favoritesMovies
        )
    );
  }
}