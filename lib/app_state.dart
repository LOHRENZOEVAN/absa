import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _Name = await secureStorage.getString('ff_Name') ?? _Name;
    });
    await _safeInitAsync(() async {
      _Email = await secureStorage.getString('ff_Email') ?? _Email;
    });
    await _safeInitAsync(() async {
      _Balance = await secureStorage.getString('ff_Balance') ?? _Balance;
    });
    await _safeInitAsync(() async {
      _Bankname = await secureStorage.getString('ff_Bankname') ?? _Bankname;
    });
    await _safeInitAsync(() async {
      _Accountnumber =
          await secureStorage.getInt('ff_Accountnumber') ?? _Accountnumber;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  String _Name = '';
  String get Name => _Name;
  set Name(String _value) {
    _Name = _value;
    secureStorage.setString('ff_Name', _value);
  }

  void deleteName() {
    secureStorage.delete(key: 'ff_Name');
  }

  String _Email = '';
  String get Email => _Email;
  set Email(String _value) {
    _Email = _value;
    secureStorage.setString('ff_Email', _value);
  }

  void deleteEmail() {
    secureStorage.delete(key: 'ff_Email');
  }

  String _Balance = '';
  String get Balance => _Balance;
  set Balance(String _value) {
    _Balance = _value;
    secureStorage.setString('ff_Balance', _value);
  }

  void deleteBalance() {
    secureStorage.delete(key: 'ff_Balance');
  }

  String _Bankname = '';
  String get Bankname => _Bankname;
  set Bankname(String _value) {
    _Bankname = _value;
    secureStorage.setString('ff_Bankname', _value);
  }

  void deleteBankname() {
    secureStorage.delete(key: 'ff_Bankname');
  }

  int _Accountnumber = 0;
  int get Accountnumber => _Accountnumber;
  set Accountnumber(int _value) {
    _Accountnumber = _value;
    secureStorage.setInt('ff_Accountnumber', _value);
  }

  void deleteAccountnumber() {
    secureStorage.delete(key: 'ff_Accountnumber');
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
