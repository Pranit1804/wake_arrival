import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wake_arrival/models/home/data/entity/home_geofencing_detail_entity.dart';
import 'package:wake_arrival/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  static late final Store obStore;
  static const String dbName = 'wake-arrival-objectbox_v1';

  static late final Box<HomeGeofencingDetailEntity> _homeGeoFencingDetailBox;

  ObjectBox._create(this.store) {
    _homeGeoFencingDetailBox = Box<HomeGeofencingDetailEntity>(store);
  }

  static Future<ObjectBox> create({
    String? directoryPath,
    String? macOSGroup,
  }) async {
    final docsDir = await getApplicationDocumentsDirectory();
    try {
      if (Store.isOpen(p.join(docsDir.path, dbName))) {
        final store = Store.attach(
          getObjectBoxModel(),
          p.join(docsDir.path, dbName),
        );
        obStore = store;
        return ObjectBox._create(store);
      } else {
        final store = await openStore(directory: p.join(docsDir.path, dbName));
        obStore = store;

        return ObjectBox._create(store);
      }
    } catch (e) {
      final store = await openStore(directory: p.join(docsDir.path, dbName));
      return ObjectBox._create(store);
    }
  }

  static Box<HomeGeofencingDetailEntity> getHomeGeofencingDetailEntity() =>
      _homeGeoFencingDetailBox;
}
