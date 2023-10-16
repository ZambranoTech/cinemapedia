import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {


  final SearchMoviesCallBack searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoading = StreamController.broadcast();

  String previousQuery;
  bool queryHasChanged = false;

  Timer? _debounceTimer;

  SearchMovieDelegate({ 
    required this.searchMovies,
    required this.initialMovies,
    required this.previousQuery
    }):super(
      searchFieldLabel: 'Buscar películas'
    );

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChanged( String query ) {
    
    // to check that the list was started previously and not make a request again.
    if (previousQuery != query || queryHasChanged){
    queryHasChanged = true;
    isLoading.add(true);

    if ( _debounceTimer?.isActive ?? false) _debounceTimer!.cancel();


    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);

      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoading.add(false);
      
    });
    }

  }


  @override
  List<Widget>? buildActions(BuildContext context) {

    return[
      StreamBuilder(
        initialData: false,
        stream: isLoading.stream, 
        builder: (context, snapshot) {

          if (snapshot.data ?? false) {
            return  SpinPerfect(
              duration: const Duration(seconds: 2),
              infinite: true,
              child: IconButton(onPressed: query.isNotEmpty? () => query = '' : null, 
              icon: const Icon(Icons.refresh_rounded),
              )
            );
          }
          
        return  FadeIn(
          animate: query.isNotEmpty,
          child: IconButton(onPressed: query.isNotEmpty? () => query = '' : null, 
          icon: const Icon(Icons.clear))
        );

        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
     return IconButton(
      onPressed: () {  
      clearStreams();
      close(context, null); 
      }, 
      icon: const Icon(Icons.arrow_back_ios_new_outlined)
      );
  }

  Widget buildResultsAndSuggestions() {

    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
      
      final movies = snapshot.data ?? [];

      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
        return _MovieItem(
          movie: movies[index],
          onMovieSelected: (context, movie) {
            clearStreams();
            close(context, movie);
          },
          );
      },
      );
    },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
   return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return buildResultsAndSuggestions();

  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
    
            // Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  height: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                  image: NetworkImage(movie.posterPath),
                ),
              ),
            ),
    
            const SizedBox(width: 10,),
    
            // Description
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium,),
    
                  (movie.overview.length > 100)
                  ?  Text( '${movie.overview.substring(0, 100)}...' )
                  : Text(movie.overview),
    
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                      const SizedBox(width: 5,),
                      Text(
                      HumanFormats.number(movie.voteAverage, 1 ),
                      style: textStyles.bodyMedium!.copyWith(color:Colors.yellow.shade900 ),),
                    ],
                  )
    
                 
    
                ],
              ),
            )
    
    
          ],
        ),
        
        ),
    );
  }
}