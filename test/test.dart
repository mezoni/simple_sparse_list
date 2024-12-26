import 'package:simple_sparse_list/ranges_helper.dart';
import 'package:simple_sparse_list/simple_sparse_list.dart';
import 'package:test/test.dart';

void main() {
  _testNormalizeRanges();
  _testSortRanges();
  _testSparseList();
}

void _testNormalizeRanges() {
  test('Normalize ranges', () {
    {
      final r1 = [(0, 0)];
      final r2 = normalizeRanges(r1);
      final r3 = [(0, 0)];
      expect(r2, r3);
    }
    {
      final r1 = [(0, 2), (0, 0)];
      final r2 = normalizeRanges(r1);
      final r3 = [(0, 2)];
      expect(r2, r3);
    }
    {
      final r1 = [(3, 5), (0, 0), (0, 2)];
      final r2 = normalizeRanges(r1);
      final r3 = [(0, 5)];
      expect(r2, r3);
    }
    {
      final r1 = [(4, 10), (11, 15), (0, 5)];
      final r2 = normalizeRanges(r1);
      final r3 = [(0, 15)];
      expect(r2, r3);
    }
    {
      final r1 = [(0, 1), (2, 3), (4, 5), (6, 7)];
      final r2 = normalizeRanges(r1);
      final r3 = [(0, 7)];
      expect(r2, r3);
    }
    {
      final r1 = [(5, 10), (0, 1), (5, 11), (15, 20), (6, 7)];
      final r2 = normalizeRanges(r1);
      final r3 = [(0, 1), (5, 11), (15, 20)];
      expect(r2, r3);
    }
    {
      final r1 = [(5, 10), (0, 1), (5, 11), (15, 20), (4, 7)];
      final r2 = normalizeRanges(r1);
      final r3 = [(0, 1), (4, 11), (15, 20)];
      expect(r2, r3);
    }
    {
      final r1 = [(1, 3), (2, 4), (3, 5), (4, 6)];
      final r2 = normalizeRanges(r1);
      final r3 = [(1, 6)];
      expect(r2, r3);
    }
  });
}

void _testSortRanges() {
  test('Sort ranges', () {
    {
      final r1 = [
        (0, 0),
      ];
      final r2 = sortRanges(r1);
      final r3 = [
        (0, 0),
      ];
      expect(r2, r3);
    }
    {
      final r1 = [
        (1, 15),
        (0, 0),
        (1, 5),
      ];
      final r2 = sortRanges(r1);
      final r3 = [
        (0, 0),
        (1, 5),
        (1, 15),
      ];
      expect(r2, r3);
    }
    {
      final r1 = [(5, 10), (0, 1), (5, 11), (15, 20), (4, 7)];
      final r2 = sortRanges(r1);
      final r3 = [
        (0, 1),
        (4, 7),
        (5, 10),
        (5, 11),
        (15, 20),
      ];
      expect(r2, r3);
    }
    {
      final r1 = [(5, 10), (0, 1), (5, 11), (15, 20), (6, 7)];
      final r2 = sortRanges(r1);
      final r3 = [
        (0, 1),
        (5, 10),
        (5, 11),
        (6, 7),
        (15, 20),
      ];
      expect(r2, r3);
    }
  });
}

void _testSparseList() {
  void iterate<E>(List<(int, int, E)> data, E defaultValue) {
    final length = data.isEmpty ? 0 : data.last.$2 + 1;
    final list = List<E>.filled(length, defaultValue);
    for (final element in data) {
      final start = element.$1;
      final end = element.$2;
      final value = element.$3;
      for (var i = start; i <= end; i++) {
        list[i] = value;
      }
    }

    final sparseList = SparseList(data, defaultValue);
    expect(list.length, list.length, reason: 'List length');
    for (var i = 0; i < sparseList.length; i++) {
      final actual = sparseList[i];
      final expected = list[i];
      expect(actual, expected, reason: 'Value at index $i');
    }
  }

  test('SparseList', () {
    {
      final data = <(int, int, String?)>[];
      iterate(data, null);
    }
    {
      final data = <(int, int, int?)>[];
      for (var i = 0; i < 100; i++) {
        data.add((i, i, i));
      }

      iterate(data, null);
    }
    {
      final data = <(int, int, int?)>[];
      for (var i = 0; i < 100; i++) {
        final start = i * 10;
        data.add((start, start + 5, i));
      }

      iterate(data, null);
    }
    {
      final data = [
        (1, 0, null),
      ];
      expect(() => SparseList(data, null), throwsA(isA<ArgumentError>()));
    }
    {
      final data = [
        (0, 10, null),
        (5, 15, null),
      ];
      expect(() => SparseList(data, null), throwsA(isA<ArgumentError>()));
    }
  });
}
