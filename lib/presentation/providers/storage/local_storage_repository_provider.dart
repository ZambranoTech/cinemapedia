

import 'package:cinemapedia/Infrastructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/Infrastructure/repositories/local_storage_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: IsarDataSource());
});