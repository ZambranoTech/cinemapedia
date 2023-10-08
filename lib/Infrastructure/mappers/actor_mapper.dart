import 'package:cinemapedia/Infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

class ActorMapper {
  static Actor castToEntity( Cast cast) =>
      Actor(
        id: cast.id, 
        name: cast.name, 
        profilePath: cast.profilePath != null 
        ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
        : 'https://st3.depositphotos.com/4111759/13425/v/450/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg', 
        character: cast.character
        );
}
