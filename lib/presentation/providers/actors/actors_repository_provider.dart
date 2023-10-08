


import 'package:cinemapedia/Infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/Infrastructure/repositories/actor_respositroy_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider((ref) {
return ActorRepositoryImpl(datasource: ActorMovieDbDatasource());
});

