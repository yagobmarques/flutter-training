import 'package:flutter_contatos/entity/contato.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContatoDAO {
  // Usando o padrão Singleton
  static final ContatoDAO _instance = ContatoDAO.internal();

  factory ContatoDAO() => _instance;

  ContatoDAO.internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      // Cria um BD apenas uma vez
      _db = await initDb();
    }
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactos.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          // Criando a tabela de contato
          "CREATE TABLE ${Contato.contactTable}(${Contato.idColumn} INTEGER PRIMARY KEY, "
          "                                 ${Contato.nameColumn} TEXT, "
          "                                 ${Contato.emailColumn} TEXT, "
          "                                 ${Contato.phoneColumn} TEXT, "
          "                                 ${Contato.imgColumn} TEXT) ");
    });
  }

  Future<Contato> inserirContato(Contato c) async {
    Database dbContact = await db;
    // insert é uma função pronta do SQLite
    c.id = await dbContact.insert(Contato.contactTable, c.toMap());
    return c;
  }

  Future<Contato> buscaContatoPeloId(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(Contato.contactTable,
        columns: [
          Contato.idColumn,
          Contato.nameColumn,
          Contato.emailColumn,
          Contato.phoneColumn,
          Contato.imgColumn
        ],
        where: "${Contato.idColumn} = ?",
        whereArgs: [id]); // Filtrando a busca pelo ID

    if (maps.length > 0)
      return Contato.fromMap(
          maps.first); //Usadoo first, mas o BD deve reornar apenas 1
    else
      return null;
  }

  Future<int> removerContato(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(Contato.contactTable,
        where: "${Contato.idColumn} = ?", whereArgs: [id]); //Filtrando pelo id
  }

  Future<int> alterarContato(Contato c) async {
    Database dbContact = await db;
    return await dbContact.update(Contato.contactTable, c.toMap(),
        where: "${Contato.idColumn} = ?", whereArgs: [c.id]);
  }
   Future<List> buscaTodosContatos() async {
    Database dbContact = await db;
    List listMap = await dbContact.query(Contato.contactTable); //Retorna todas as Tuplas
    List<Contato> listContacts = List();
    for (Map m in listMap) {
      listContacts.add(Contato.fromMap(m));
    }
    return listContacts;
  }
    Future<int> pegaTamanho() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact
        .rawQuery("select count(*) from ${Contato.contactTable}")); //Retorna a quantidade de tuplas
  }
}
