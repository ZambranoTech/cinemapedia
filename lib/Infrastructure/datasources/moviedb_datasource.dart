import 'package:cinemapedia/Infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia/Infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/Infrastructure/models/moviedb/videos_response.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/Infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/Infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      queryParameters: {
        'api_key': Enviroment.theMovieDbKey,
        'language': 'es'
      }));

  List<Movie> _jsonToMovies( Map<String, dynamic> json ) {
  
    final movieDBResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDBResponse.results
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {

    final response = await dio.get('/movie/now_playing', 
    queryParameters: {
      'page': page
    });

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {

    final response = await dio.get('/movie/popular', 
      queryParameters: {
        'page': page
      });

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {

    final response = await dio.get('/movie/top_rated', 
      queryParameters: {
        'page': page
      });

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    
     final response = await dio.get('/movie/upcoming', 
      queryParameters: {
        'page': page
      });

    return _jsonToMovies(response.data);

  }
  
  @override
  Future<Movie> getMovieById(String id) async {
     final response = await dio.get('/movie/$id');
     if (response.statusCode != 200) throw Exception('Movie with id: $id not found');
    
     final movieDetails = MovieDetails.fromJson(response.data);
     final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
     return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {

    if (query.isEmpty) return [];

     final response = await dio.get('/search/movie', 
      queryParameters: {
        'query': query
      });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int id) async {
    final response = await dio.get('/movie/$id/videos');

    final moviedbVideoResponse = MoviedbVideoResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideoResponse.results) {
      if (moviedbVideo.site == 'YouTube') {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }
  
  @override
  Future<List<Movie>> getSimilarMovies(int id) async {
    final response = await dio.get('/movie/$id/similar');
    return _jsonToMovies(response.data);
  }


}
