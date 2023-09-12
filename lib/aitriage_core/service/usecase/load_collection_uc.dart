import '../service/local_storage_service/database/repository/isar_database_repository.dart';

class LoadCollectionUseCase {
  Future<List<T>> execute<T>() async {
    return await DatabaseRepository.readAll<T>();
  }
}