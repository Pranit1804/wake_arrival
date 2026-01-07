import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:wake_arrival/models/home/data/alarm_model.dart';
import 'package:wake_arrival/objectbox.g.dart';

class ObjectBoxService {
  static ObjectBoxService? _instance;
  late final Store _store;
  late final Box<AlarmModel> _alarmBox;

  ObjectBoxService._create(this._store) {
    _alarmBox = _store.box<AlarmModel>();
  }

  static Future<ObjectBoxService> getInstance() async {
    try {
      if (_instance == null) {
        final docsDir = await getApplicationDocumentsDirectory();
        final store =
            await openStore(directory: p.join(docsDir.path, 'objectbox'));
        _instance = ObjectBoxService._create(store);
      }
      return _instance!;
    } catch (e) {
      print(e);
    }
    return _instance!;
  }

  Box<AlarmModel> get alarmBox => _alarmBox;

  void close() {
    _store.close();
  }
}
