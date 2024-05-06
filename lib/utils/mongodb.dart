import 'package:mongo_dart/mongo_dart.dart' as mongo;

/// convert an objectID to string
String? objectIdToString(mongo.ObjectId? item) {
  if (item == null) return null;

  return item.oid;
}

/// convert an objectID to string
String objectIdToStringKnown(mongo.ObjectId item) {
  return item.oid;
}

/// convert an string to objectId
mongo.ObjectId? stringToObjectId(String? item) {
  if (item == null) return null;

  return mongo.ObjectId.parse(item);
}

/// convert an string to objectId
mongo.ObjectId stringToObjectIdKnown(String item) {
  return mongo.ObjectId.parse(item);
}

/// convert an objectID to string
List<String?> objectIdToStringList(List<mongo.ObjectId?> items) {
  return items.map((item) {
    if (item == null) return null;

    return item.oid;
  }).toList();
}

/// convert an objectID to string
List<String> objectIdToStringListKnown(List<mongo.ObjectId> items) {
  return items.map((item) {
    return item.oid;
  }).toList();
}

/// convert an objectID to string
List<String> objectIdToStringListKnownDynamic(List<dynamic> items) {
  return items.map((item) {
    return item.oid as String;
  }).toList();
}

/// convert an string to objectId
List<mongo.ObjectId?> stringToObjectIdList(List<String?> items) {
  return items.map((item) {
    if (item == null) return null;

    return mongo.ObjectId.parse(item);
  }).toList();
}

/// convert an string to objectId
List<mongo.ObjectId> stringToObjectIdListKnown(List<String> items) {
  return items.map((item) {
    return mongo.ObjectId.parse(item);
  }).toList();
}

/// convert an string to objectId
List<dynamic> stringToObjectIdListKnownDynamic(List<String> items) {
  return items.map((item) {
    return mongo.ObjectId.parse(item);
  }).toList();
}
