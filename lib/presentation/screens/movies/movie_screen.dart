import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/widgets/movies/similar_movies.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
    });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }


  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 2,),));
    }

    return Scaffold(
      body: CustomScrollView(
          
          physics: const ClampingScrollPhysics(),

          slivers: [
            _CustomSliverAppBar(movie: movie),
            SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1
              
              )),
          ],
        ),
    );
  }
}

class _MovieDetails extends StatelessWidget {

  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //* Titulo, OverView y Rating
       _TitleAndOverview(movie: movie, size: size, textStyles: textStyles),

        //*  Generos de la película
        _Genres(movie: movie),

        //* Actores
        ActorsByMovie(movieId: movie.id.toString()),

        //* Videos de la pelicula (si tiene)
        VideosFromMovie(movieId: movie.id),

        //* Peliculas similares
        SimilarMovies(movieId: movie.id),

      ],
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Wrap(
        children: [
          ...movie.genreIds.map((gender) => Container(
            margin: const EdgeInsets.only(right: 10),
            child: Chip(
              label: Text(gender),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
          )),


        ],
      ),
      );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({
    required this.movie,
    required this.size,
    required this.textStyles,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.all(8),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [

        // Imagen 
         ClipRRect(
           borderRadius: BorderRadius.circular(20),
           child: Image.network(
             movie.posterPath,
             width: size.width * 0.3,
             ),
         ),

         const SizedBox(width: 10,),

        //Descripción
         SizedBox(
           width: (size.width - 40) * 0.7,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [

              Text(movie.title, style: textStyles.titleLarge),
              Text(movie.overview),

              const SizedBox(height: 10,),

              MovieRating(movie: movie),

              const SizedBox(height: 5,),
              
              Row(
                children: [
                  const Text('Estreno: ', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(width: 5,),
                  Text(HumanFormats.shortDate(movie.releaseDate)),
                ],
              )



             ],
           )
         )
       ],
     ),
    );
  }
}



final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
    return localStorageRepository.isMovieFavorite(movieId); 
});

class _CustomSliverAppBar extends ConsumerWidget { 

  final Movie movie;
  
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, ref) {

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;

    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;


    return SliverAppBar(
      
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(onPressed: () async {
          // await ref.read( localStorageRepositoryProvider )
          //   .toggleFavorite(movie);

          await ref.read( favoriteMoviesProvider.notifier)
            .toggleFavorite(movie);

          ref.invalidate(isFavoriteProvider(movie.id));

        },
        icon: isFavoriteFuture.when(
        data: (isFavorite) => isFavorite
        ? const Icon(Icons.favorite, color: Colors.red,) 
        : const Icon(Icons.favorite_border),
        error: (_, __ ) => throw UnimplementedError(), 
        loading: () => const CircularProgressIndicator(strokeWidth: 2,))
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        centerTitle: true,
        title: _CustomGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.7, 1.0],
          colors: [
            Colors.transparent,
            scaffoldBackgroundColor
          ]
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
                ),
            ),

             //* Back arrow background
            const _CustomGradient(
              begin: Alignment.topLeft, 
              stops: [0.0, 0.2], 
              colors: [Colors.black54,
                      Colors.transparent],
              
                      ),

            //* Favorite Gradient Background
             const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft, 
              stops: [0.0, 0.2], 
              colors: [Colors.black54,
                      Colors.transparent],
              
                      ),
            

            const _CustomGradient(
              begin: Alignment.topCenter, 
              stops: [0.7, 1.0], 
              colors: [Colors.transparent,
                      Colors.black87],
              end: Alignment.bottomCenter,
                      ),

            

           
            
          ]
        ),
      ),

    );
  }
}

class _CustomGradient extends StatelessWidget {

  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final List<Color> colors;


  const _CustomGradient({
    this.begin = Alignment.center, 
    this.end = Alignment.centerRight, 
    required this.colors, 
    required this.stops,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops, 
            colors: colors
            )
        )
        ),
    );
  }
}