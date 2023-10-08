



import 'package:cinemapedia/Infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/Infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3/',
    queryParameters: {
      'api_key' : Enviroment.theMovieDbKey,
      'language' : 'es'
    }
    ));
  
  
  
  @override
  Future<List<Actor>> getActorByMovie(String movieId) async {
    final response = await dio.get('movie/$movieId/credits');

    final creditsResponse = CreditsResponse.fromJson(response.data);

    final List<Actor> actors = creditsResponse.cast
    .map((cast) => ActorMapper.castToEntity(cast))
    .toList();


    return actors;
  }





}