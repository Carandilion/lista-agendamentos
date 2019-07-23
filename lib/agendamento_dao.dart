import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'agendamento.dart';

class AgendamentoDao {
  static const String TABLE_NAME = 'Agendamentos';
  static const DATABASE_VERSION = 2;

  AgendamentoDao() {
    initializeDatabase();
    updateTables();
  }

  initializeDatabase() async {
    openDatabase(join(await getDatabasesPath(), 'lista_agendamentos.db'),
        onCreate: (db, version) {
      db.execute("CREATE TABLE IF NOT EXISTS $TABLE_NAME"
          "("
          "id INTEGER PRIMARY KEY, nome TEXT, data TEXT, uploaded integer);");
    }, version: DATABASE_VERSION);
  }

  Future updateTables() async {
    var db = await getDatabase();
    num cv = await db.getVersion();
    if (cv < DATABASE_VERSION) {
      switch (cv) {
        case 1:
          db.execute("ALTER TABLE Agendamentos ADD uploaded integer");
      }
      db.setVersion(DATABASE_VERSION);
    }
  }

  Future<List<Agendamento>> getAgendamentos() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return List.generate(maps.length, (i) {
      var c = maps[i];
      DateTime data;
      data = DateTime.tryParse(c['data']);
      Agendamento a = Agendamento(c['nome'], data);
      a.id = c['id'];
      return a;
    });
  }

  Future insertAgendamento(Agendamento agendamento) async {
    final db = await getDatabase();
    db.insert(TABLE_NAME, agendamento.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    db.close();
  }

  Future<Database> getDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'lista_agendamentos.db'));
  }

  deleteAgendamento(Agendamento agendamento) {}
}
