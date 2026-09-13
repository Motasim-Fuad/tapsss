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
