import 'package:academico_fema_app/model/professor.dart';
import 'package:academico_fema_app/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class ProfessorRepository {
  Future<int> save(Professor professor) async {
    final sql.Database database = await DatabaseProvider.instance.database;
    return await database.insert('PROFESSORES', professor.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Professor>> findAll() async {
    final sql.Database database = await DatabaseProvider.instance.database;
    final professoresMap = await database.query('PROFESSORES', orderBy: 'STATUS, NOME');
    final List<Professor> professores = _toList(professoresMap);
    return professores;
  }

    Future<List<Professor>> findByNome(String? nome) async {
    if (nome == null || nome.isEmpty) {
      return findAll();
    }
    final sql.Database database = await DatabaseProvider.instance.database;
    final professoresMap = await database.query('PROFESSORES',
        where: 'NOME LIKE ?',
        whereArgs: [
          '%$nome%'
        ],
        orderBy: 'STATUS, MATRICULA');
    final List<Professor> professores = _toList(professoresMap);
    return professores;
  }

  Future<void> clear() async {
    final sql.Database database = await DatabaseProvider.instance.database;
    database.rawDelete('DELETE FROM PROFESSORES');
  }

    List<Professor> _toList(List<Map<String, Object?>> values) {
    return values.isEmpty ? List.empty() : values.map((e) => Professor.fromMap(e)).toList();
  }
}