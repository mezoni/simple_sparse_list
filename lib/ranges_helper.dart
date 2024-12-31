/// Combines [ranges] of values ​​by calling the [combine] function, comparing
/// values ​​by calling the [compare] function.
///
/// Returns a new array with the combined values ​​sorted in ascending range
/// order.
List<(int, int, T)> combineRanges<T>(
  List<(int, int, T)> ranges, {
  required T Function(T x, T y) combine,
  required bool Function(T x, T y) compare,
}) {
  ranges = ranges.toList();
  if (ranges.isEmpty) {
    return ranges;
  }

  ranges.sort((a, b) {
    if (a.$1 != b.$1) {
      return a.$1.compareTo(b.$1);
    }

    return a.$2.compareTo(b.$2);
  });

  for (var i = 0; i < ranges.length; i++) {
    final range = ranges[i];
    final start = range.$1;
    final end = range.$2;
    if (start > end) {
      throw ArgumentError('Invalid range at index $i: ($start, $end)');
    }
  }

  final result = <(int, int, T)>[];
  var lastIndex = 0;
  result.add(ranges.first);
  for (var i = 1; i < ranges.length; i++) {
    final curr = ranges[i];
    final affected = result.sublist(lastIndex);
    final buffer = <(int, int, T)>[];
    var maxEnd = -1;
    for (var i = 0; i < affected.length; i++) {
      final prev = affected[i];
      if (maxEnd < prev.$2) {
        maxEnd = prev.$2;
      }

      if (prev.$2 < curr.$1 - 1) {
        lastIndex++;
        continue;
      }

      if (prev.$2 == curr.$1 - 1) {
        final equal = compare(prev.$3, curr.$3);
        if (equal) {
          if (maxEnd < curr.$2) {
            maxEnd = curr.$2;
          }

          buffer.add((prev.$1, curr.$2, prev.$3));
        } else {
          buffer.add((prev.$1, prev.$2, prev.$3));
        }

        continue;
      }

      var pos = prev.$1;
      if (pos < curr.$1) {
        // add 'prev'
        buffer.add((prev.$1, curr.$1 - 1, prev.$3));
        pos = curr.$1;
      }

      // pos2 = min (prev.$2, curr.$2)
      final pos2 = prev.$2 < curr.$2 ? prev.$2 : curr.$2;
      // 'prev.$2' + 'curr.$2'
      final v = combine(prev.$3, curr.$3);
      buffer.add((pos, pos2, v));
    }

    // Rest of 'curr'
    if (curr.$2 > maxEnd) {
      var start = maxEnd + 1;
      if (start < curr.$1) {
        start = curr.$1;
      }

      buffer.add((start, curr.$2, curr.$3));
    }

    for (var j = 0; j < buffer.length; j++) {
      final value = buffer[j];
      final index = lastIndex + j;
      if (index < result.length) {
        result[index] = value;
      } else {
        result.add(value);
      }
    }
  }

  return result;
}

/// Normalizes ranges by sorting and merging them.
///
/// Returns a new array with the merged values ​​sorted in ascending range order.
List<(int, int)> normalizeRanges(List<(int, int)> ranges) {
  if (ranges.isEmpty) {
    return ranges.toList();
  }

  for (var i = 0; i < ranges.length; i++) {
    final range = ranges[i];
    final start = range.$1;
    final end = range.$2;
    if (start > end) {
      throw ArgumentError('Invalid range at index $i: ($start, $end)');
    }
  }

  ranges = sortRanges(ranges);
  final result = <(int, int)>[];
  final first = ranges.first;
  result.add(ranges.first);
  var prevStart = first.$1;
  var prevEnd = first.$2;
  for (var i = 1; i < ranges.length; i++) {
    final curr = ranges[i];
    final start = curr.$1;
    final end = curr.$2;
    if (start <= prevEnd + 1) {
      prevEnd = prevEnd > end ? prevEnd : end;
      result[result.length - 1] = (prevStart, prevEnd);
    } else {
      prevStart = start;
      prevEnd = end;
      result.add((start, end));
    }
  }

  return result;
}

/// Sorts [ranges] in ascending order.
///
/// Returns a new array with ranges sorted in ascending order.
List<(int, int)> sortRanges(List<(int, int)> ranges) {
  final result = ranges.toList();
  if (result.isEmpty) {
    return result.toList();
  }

  result.sort((a, b) {
    if (a.$1 != b.$1) {
      return a.$1.compareTo(b.$1);
    }

    return a.$2.compareTo(b.$2);
  });

  return result;
}
