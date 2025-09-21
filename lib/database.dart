
import 'dart:collection';
import 'dart:io';

import 'package:assignment/classes/delivery.dart';
import 'package:assignment/classes/part.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef Json = Map<String, dynamic>;

class Database {
  static late final SupabaseClient supabase;
  static const partTable = 'parts';
  static const deliveryTable = 'deliveries';
  static const imagesBucket = 'images';

  static List<Part> _parts = [];
  static final Map<int, Part> _partsMap = {};
  static List<Delivery> _deliveries = [];
  static final Map<int, Delivery> _deliveriesMap = {};

  static UnmodifiableListView<Part> get parts => UnmodifiableListView(_parts);
  static UnmodifiableMapView<int, Part> get partsMap => UnmodifiableMapView(_partsMap);
  static UnmodifiableListView<Delivery> get deliveries => UnmodifiableListView(_deliveries);
  static UnmodifiableMapView<int, Delivery> get deliveriesMap => UnmodifiableMapView(_deliveriesMap);

  static Future<void> init(String url, String key) async {
    await Supabase.initialize(url: url, anonKey: key);
    supabase = Supabase.instance.client;
  }

  static Future<List<Part>> fetchParts() async =>
      (await supabase.from(partTable).select()).map(Part.fromJson).toList();
  
  static Future<List<Delivery>> fetchDeliveries() async =>
      (await supabase.from(deliveryTable).select()).map(Delivery.fromJson).toList();

  static Future<void> fetch() async {
    _parts = await fetchParts();
    _deliveries = await fetchDeliveries();
    _partsMap.clear();
    _deliveriesMap.clear();

    for (final part in _parts) {
      _partsMap[part.id] = part;
    }

    for (final delivery in _deliveries) {
      _deliveriesMap[delivery.id] = delivery;
    }
  }

  static Future<String> uploadFile(String path, File file, {bool overwrite = false}) async {
    final bucket = supabase.storage.from(imagesBucket);
    await bucket.upload(path, file, fileOptions: FileOptions(upsert: overwrite));
    return bucket.getPublicUrl(path);
  }
}
