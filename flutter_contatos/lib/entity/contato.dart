  // Classe para salvar os dados de um contato
class Contato {
  // Colunas e tabela do BD
  static final String contactTable = "contactTable";
  static final String idColumn = "idColumn";
  static final String nameColumn = "nameColumn";
  static final String phoneColumn = "phoneColumn";
  static final String emailColumn = "emailColumn";
  static final String imgColumn = "imgColumn";

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contato();

  Contato.fromMap(Map map){
    this.id = map[idColumn];
    this.name = map[nameColumn];
    this.email = map[emailColumn];
    this.phone = map[phoneColumn];
    this.img = map[imgColumn];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      idColumn: this.id,
      nameColumn: this.name,
      emailColumn: this.email,
      phoneColumn: this.phone,
      imgColumn: this.img
    };
    return map;
  }

  String toString(){
    return "Contato(id: ${this.id}, name: ${this.name}, email: ${this.email}, phone: ${this.phone}, img: ${this.img})";
  }

}