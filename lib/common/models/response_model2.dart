class ResponseModel2 {
  final bool _isSuccess;
  final String? _message;
  final dynamic _data;
  ResponseModel2(this._isSuccess, this._message, this._data);
  String? get message => _message;
  bool get isSuccess => _isSuccess;
  dynamic get data => _data;
}
