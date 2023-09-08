import 'package:isar/isar.dart';
import '../provider/isar_provider.dart';

class DatabaseRepository<T> {
  final _db = IsarProvider.instance.collection<T>();

  /// Get a single object by its id or null if the object does not exist
  Future<T?> readById(int id) async {
    return await _db.get(id);
  }

  /// Get a list of objects by their ids or null if an object does not exist.
  Future<List<T?>> readByMultipleId(List<int> listId) async {
    return await _db.getAll(listId);
  }

  /// Find all objects.
  Future<List<T>> readAll() async {
    return await _db.where().findAll();
  }

  /// Insert or update an object. Returns the id of the new or updated object.
  /// If the object has an non-final id property, it will be set to the assigned id.
  /// Otherwise you should use the returned id to update the object
  Future<int> write(T object) async {
    return IsarProvider.instance.writeTxn(() async => await _db.put(object));
  }

  /// Delete a single object by its id.
  /// Returns whether the object has been deleted
  Future<bool> deleteById(int id) async {
    return await _db.delete(id);
  }

  /// Delete all objects. Returns the number of deleted objects
  Future<int> deleteAll() async {
    return await IsarProvider.instance.writeTxn(() async => await _db.where().deleteAll());
  }
}