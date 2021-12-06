String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, Iterable<T> values) => values.firstWhere(
      (v) => v != null && key == enumToString(v),
      orElse: () => throw NullThrownError(),
    );

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String? validator(String? e) => e == null
    ? 'Field can\'t be empty'
    : e.isEmpty
        ? 'FIELD CAN\'T BE EMPTY'
        : null;
