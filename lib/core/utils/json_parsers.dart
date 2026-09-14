int asInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.round();
  final parsed = num.tryParse(value.toString().replaceAll('%', '').trim());
  return parsed?.round() ?? fallback;
}

int? asIntOrNull(dynamic value) {
  if (value == null) return null;
  return asInt(value);
}

Map<String, dynamic> asJsonMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> asJsonMapList(dynamic value) {
  if (value is! List) return const [];
  return value.map(asJsonMap).toList();
}

Map<String, String> asStringMap(dynamic value) {
  if (value is! Map) return const {};
  return value.map((key, val) => MapEntry(key.toString(), val.toString()));
}

String asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}
