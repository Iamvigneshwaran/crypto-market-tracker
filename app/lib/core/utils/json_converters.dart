double toDouble(Object? v) => (v as num?)?.toDouble() ?? 0;
double? toDoubleOrNull(Object? v) => (v as num?)?.toDouble();
int toInt(Object? v) => (v as num?)?.toInt() ?? 0;
int? toIntOrNull(Object? v) => (v as num?)?.toInt();
List<double> toDoubleList(Object? v) =>
    (v as List?)?.map((e) => (e as num).toDouble()).toList() ?? const [];
List<String> toStringList(Object? v) =>
    (v as List?)?.whereType<String>().toList() ?? const [];