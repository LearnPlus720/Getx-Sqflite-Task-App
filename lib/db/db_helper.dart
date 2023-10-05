import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';


class DBHelper {
  static Database? _db;
  static final _dbVersion = 1;
  static final _tableName = "tasks";

  // DatabaseHelper._privateConstructor();
  // static final DatabaseHelper instance
  // = DatabaseHelper._privateConstructor();

  static final _dbName = "notes.db";



  // static Database _database;


  // Future<Database> get database async {
  //   if (_database != null) return _database;
  //   _database = await _initiateDatabase();
  //   return _database;
  // }

  static Future<void> initDb() async{
      if(_db != null){
        return;
      }
      try{
          String _path = await getDatabasesPath() + 'tasks.db';
          _db = await openDatabase(
            _path,
            version: _dbVersion,
            onCreate: (db , version){
              print("creating a new DB");
              return db.execute('''
                  CREATE TABLE $_tableName(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title STRING ,
                    note TEXT,
                    date STRING,
                    startTime STRING,
                    endTime STRING,
                    remind INTEGER,
                    repeat STRING,
                    color INTEGER,
                    isCompleted INTEGER)
                  ''');
            }
          );
      }catch(e){
              print(e);
      }
  }
  // Future <Database> get database async{
  //   return _database ??= await _initiateDatabase();
  // }
  //
  // _initiateDatabase() async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = join(directory.path, _dbName);
  //   return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  // }
  //
  // Future<void> _onCreate(Database db, int version) {
  //   return db.execute('''
  //     CREATE TABLE $_tableName(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       title TEXT NOT NULL,
  //       content TEXT NOT NULL,
  //       dateTimeEdited TEXT NOT NULL,
  //       dateTimeCreated TEXT NOT NULL
  //     )
  //     ''');
  // }

  // Add Note
  static Future<int> insert(Task? task) async {
    print("insert new task to DB");
    // Database db = await instance.database;
    return await _db?.insert(_tableName, task!.toJson())??0;
  }

  static Future<List<Map<String, dynamic>>> query() async{
    print("Query Function Called");
    return await _db!.query(_tableName);
  }

  static Future<List<Map<String, dynamic>>> select(String where) async{
    print("Select Function Called");
    // return await _db!.query(_tableName);
    return _db!.query(
                   _tableName,
                    where: where
                  );
  }

  // Delete Task
  static Future<int> deleteTask(Task task) async {
    print("Delete Task Function Called for Task ${task.id}");
    return await _db!.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [task.id],
    );
  }
  static Future<int> updateTask(Task task ) async {
    // return await _db!.rawUpdate('''
    //   UPDATE $_tableName
    //   SET isCompleted = ?
    //   WHERE id = ?
    // ''',[1,id]);
    return await _db!.update(
      _tableName,
      task.toJson(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  static Future<int> updateTaskCompleted(int id ) async {
    print("updateTaskCompleted Function Called for Task $id");

    return await _db!.rawUpdate('''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
    ''',[1,id]);
  }

//
//   // Delete All Notes
//   Future<int> deleteAllTasks() async {
//     Database db = await instance.database;
//     return await db.delete(_tableName);
//   }
//
//   // Update Note
//   Future<int> updateTask(Task task) async {
//     Database db = await instance.database;
//     return await db.update(
//       _tableName,
//       task.toMap(),
//       where: "id = ?",
//       whereArgs: [task.id],
//     );
//   }
//
//   Future<List<Task>> getTaskList() async {
//     Database db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.query(_tableName);
//
//     return List.generate(
//       maps.length,
//           (index) {
//         return Task(
//           id: maps[index]["id"],
//           title: maps[index]["title"],
//           note: maps[index]["note"],
//           isCompleted: maps[index]["isCompleted"],
//           date: maps[index]["date"],
//           startTime: maps[index]["startTime"],
//           endTime: maps[index]["endTime"],
//           color: maps[index]["color"],
//           remind: maps[index]["remind"],
//           repeat: maps[index]["repeat"],
//         );
//       },
//     );
//   }
}
