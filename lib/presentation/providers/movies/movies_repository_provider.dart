import 'package:cinemapedia/Infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/Infrastructure/repositores/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este repositorio es inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl( datasource: MoviedbDatasource() );
});

