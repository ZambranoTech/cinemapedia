import 'package:cinemapedia/Infrastructure/models/models.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

class VideoMapper {

  static Video moviedbVideoToEntity( Result moviedbVideo ) => Video(
    id: moviedbVideo.id, 
    name: moviedbVideo.name, 
    youtubeKey: moviedbVideo.key, 
    publishedAt: moviedbVideo.publishedAt);


}