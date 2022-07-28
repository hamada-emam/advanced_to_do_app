import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todotasks/data/db/db_helper.dart';
import 'package:todotasks/data/models/tasks_model.dart';

class TodoDao {
  //Adds new Todo records// POST
  Future<int> insertToDtaBase(Task? task) async {
    var db = await DBHelper.database;
    debugPrint("inserted ${task?.id}");
    var result = db.insert(DBHelper.tableName, task!.toJson());
    return result;
  }

  // LIST OF TASKS
  static List<Task> todos = [];

  // GET ALL TASKS //Get All Todo items//Searches if query string was passed
  Future<List<Task>> get() async {
    var db = await DBHelper.database;
    for (var element in todos) {
      debugPrint(element.title);
    }
    final result = await db.query(DBHelper.tableName);
    todos = result.isNotEmpty
        ? result.map((item) => Task.fromJson(item)).toList()
        : [];
    return todos;
  }

  // UPDATE STATUS
  Future<int> updateStatus(statusoffave, statusofcomplete, id) async {
    var db = await DBHelper.database;

    return await db.rawUpdate('''
    UPDATE tasks
    SET statusoffave = ?
    , statusofcomplete = ?
    WHERE id = ?
    ''', ["$statusoffave", "$statusofcomplete", id]).then((value) {
      debugPrint("updated==>  $id");
      return id;
    });
  }

  // UPDATE ALL FIELDS OF A TASK
  Future<int> updateAll(Task task) async {
    var db = await DBHelper.database;
    debugPrint(task.toString());
    return await db.rawUpdate('''
    UPDATE tasks
    SET title = ?
    , note = ?
    , date = ?
    , startTime = ?
    , endTime = ?
    , remind = ?
    , repeat = ?
    , color = ?
    WHERE id = ?
    ''', [
      "${task.title}",
      "${task.note}",
      "${task.date}",
      "${task.startTime}",
      "${task.endTime}",
      "${task.remind}",
      "${task.repeat}",
      "${task.color}",
      task.id
    ]).then((value) {
      debugPrint(task.title.toString());
      return 0;
    });
  }

  // DELETE PARTICULAR TASK
  Future<int> delete(int id) async {
    var db = await DBHelper.database;
    debugPrint("deleted $id");
    return await db
        .delete(DBHelper.tableName, where: ' id = ? ', whereArgs: [id]);
  }

  // DELETE ALL TASKS
  Future<int> deleteAll() async {
    var db = await DBHelper.database;
    debugPrint("deleted All tasks");
    return await db.delete(DBHelper.tableName);
  }
}
