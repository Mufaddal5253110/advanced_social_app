import 'dart:io';
import 'package:myapp/models/usermodal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableuser = 'user';

class DBHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyApp.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // open the database
  Future<Database> _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableuser (
                id INTEGER PRIMARY KEY,
                _id TEXT,
                firstname TEXT,
                lastname TEXT,
                fullname TEXT,
                username TEXT,
                profileImage TEXT,
                fbId TEXT,
                website TEXT,
                bio TEXT,
                followers TEXT,
                followings TEXT
              )
              ''');
  }

  // Database Insert methods
  Future<int> insert(UserModal user) async {
    Database db = await database;
    int id = await db.insert(tableuser, user.toJson());
    return id;
  }

  // Database Update methods:
  Future<int> update(UserModal user) async {
    Database db = await database;
    int id = await db.update(tableuser, user.toUpdateProfileJson(),
        where: 'id = ?', whereArgs: [user.dbID ?? 1]);
    return id;
  }

  // Database Update methods:
  Future<int> updateOther(Map<String, dynamic> data, int? dbId) async {
    Database db = await database;
    int id =
        await db.update(tableuser, data, where: 'id = ?', whereArgs: [dbId]);
    return id;
  }

  // // function to create the database
  // static Future<sql.Database> getDatabase() async {
  //   final dbpath = await sql.getDatabasesPath();
  //   return sql.openDatabase(path.join(dbpath, 'spendings.db'),
  //       onCreate: (db, version) {
  //     return db.execute(
  //         'CREATE TABLE transactions(id TEXT PRIMARY KEY,title TEXT,amount INTEGER,date TEXT,category TEXT)');
  //   }, version: 1);
  // }

  // //Inserting the transaction data
  // static Future<void> insert(Transaction transaction) async {
  //   final db = await DBHelper.getDatabase();
  //   await db.insert('transactions', transaction.toMap(transaction),
  //       conflictAlgorithm: sql.ConflictAlgorithm.replace);
  // }

  //Retereving the transaction data
  Future<UserModal> fetch() async {
    Database db = await database;
    List<Map<String, dynamic>> list = await db.query(tableuser);
    print(list);
    return UserModal.fromJson2(list[0]);
  }

  //deleting the transactions
  Future<void> delete(String id) async {
    Database db = await database;
    await db.delete(tableuser, where: "id=?", whereArgs: [id]);
  }
}
