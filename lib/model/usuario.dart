class Usuario {
  String _fotoUrl;
  String _nome;
  String _email;
  String _senha;

  Usuario(this._fotoUrl, this._nome, this._email, this._senha);

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get fotoUrl => _fotoUrl;

  set fotoUrl(String value) {
    _fotoUrl = value;
  }
}