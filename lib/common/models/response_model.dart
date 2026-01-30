class ResponseModel {
  final bool _isSuccess;
  final String? _message;
   String? msg;
  List<int>? zoneIds;
  ResponseModel(this._isSuccess, this._message, {this.msg,this.zoneIds});

  String? get message => _message;

  bool get isSuccess => _isSuccess;
}