List<(int, int)> normalizeRanges(List<(int, int)> ranges) {
  if (ranges.isEmpty) {
    throw ArgumentError('Must not be empty', 'ranges');
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
  final list = <(int, int)>[];
  final first = ranges.first;
  list.add(ranges.first);
  var prevStart = first.$1;
  var prevEnd = first.$2;
  for (var i = 1; i < ranges.length; i++) {
    final curr = ranges[i];
    final start = curr.$1;
    final end = curr.$2;
    if (start <= prevEnd + 1) {
      prevEnd = prevEnd > end ? prevEnd : end;
      list[list.length - 1] = (prevStart, prevEnd);
    } else {
      prevStart = start;
      prevEnd = end;
      list.add((start, end));
    }
  }

  return list;
}

List<(int, int)> sortRanges(List<(int, int)> data) {
  data = data.toList();
  data.sort((a, b) {
    if (a.$1 != b.$1) {
      return a.$1.compareTo(b.$1);
    }

    return a.$2.compareTo(b.$2);
  });

  return data;
}
