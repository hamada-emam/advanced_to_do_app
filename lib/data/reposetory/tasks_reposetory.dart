import 'package:todotasks/data/todo_dao/todo_dao.dart';

import '../models/tasks_model.dart';

// act as proxy bridge
// between different data sources provider
//that can orchestrate CRUD operations between them.

class TodoRepository {
  final todoDao = TodoDao();

  Future<List<Task>> getAllTodos({String? query}) => todoDao.get();

  static List<Task> get listtodos => TodoDao.todos;

  Future<int> insertTodo(Task todo) => todoDao.insertToDtaBase(todo);

  Future<int> updateAllTask(Task todo) => todoDao.updateAll(todo);

  Future<int> updateStatus(statusoffave, statusofcomplete, id) =>
      todoDao.updateStatus(statusoffave, statusofcomplete, id);

  Future<int> deleteTodoById(int id) => todoDao.delete(id);

  Future<int> deleteAllTodos() => todoDao.deleteAll();
}
