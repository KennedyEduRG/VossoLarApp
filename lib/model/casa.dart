import 'package:vossolarapp/model/usuario.dart';

class Casa {
  String _fotoUrl;
  String _titulo;
  String _bairro;
  String _rua;
  String _cidade;
  int _numero;
  int _quartos;
  int _banheiros;
  bool _possuiGaragem;
  double _preco;
  Usuario _dono;
  bool _favorito = false;
  double? latitude;
  double? longitude;

  bool get favorito => _favorito;

  Casa(
      this._fotoUrl,
      this._titulo,
      this._bairro,
      this._rua,
      this._numero,
      this._cidade,
      this._quartos,
      this._banheiros,
      this._possuiGaragem,
      this._preco,
      this._dono,
      {this.latitude,
        this.longitude}
      );

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get fotoUrl => _fotoUrl;

  set fotoUrl(String value) {
    _fotoUrl = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get rua => _rua;

  set rua(String value) {
    _rua = value;
  }

  int get numero => _numero;

  set numero(int value) {
    _numero = value;
  }

  int get quartos => _quartos;

  set quartos(int value) {
    _quartos = value;
  }

  int get banheiros => _banheiros;

  set banheiros(int value) {
    _banheiros = value;
  }

  bool get possuiGaragem => _possuiGaragem;

  set possuiGaragem(bool value) {
    _possuiGaragem = value;
  }

  double get preco => _preco;

  set preco(double value) {
    _preco = value;
  }

  Usuario get dono => _dono;

  set dono(Usuario value) {
    _dono = value;
  }

  void favoritar() {
    _favorito = !_favorito;
  }
}