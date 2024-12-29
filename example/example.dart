import 'package:simple_sparse_list/simple_sparse_list.dart';

void main(List<String> args) {
  _test(32);
  _test(48);
  _test(73);
  _test(100);
  _test(320);
  _test(0x10ffff);
}

final _data = [
  (48, 57, Letter.number),
  (65, 90, Letter.upperCase),
  (97, 122, Letter.lowerCase),
];

final _list = SparseList(_data, Letter.unknown, length: 0x10ffff + 1);

void _test(int c) {
  final kind = _list[c];
  print('$c: $kind');
}

enum Letter { lowerCase, number, unknown, upperCase }
