# simple_sparse_list

A simple and efficient implementation of an unmodifiable sparse list based on the binary search algorithm.

Version: 0.1.0

[![Pub Package](https://img.shields.io/pub/v/simple_sparse_list.svg)](https://pub.dev/packages/simple_sparse_list)
[![GitHub Issues](https://img.shields.io/github/issues/mezoni/simple_sparse_list.svg)](https://github.com/mezoni/simple_sparse_list/issues)
[![GitHub Forks](https://img.shields.io/github/forks/mezoni/simple_sparse_list.svg)](https://github.com/mezoni/simple_sparse_list/forks)
[![GitHub Stars](https://img.shields.io/github/stars/mezoni/simple_sparse_list.svg)](https://github.com/mezoni/simple_sparse_list/stargazers)
[![GitHub License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://raw.githubusercontent.com/mezoni/simple_sparse_list/main/LICENSE)

## What is it and what is it for?

This is a simple and efficient implementation of an unmodifiable sparse list based on the binary search algorithm.  
A sparse list can be used to store and process large amounts of static data specified as a large number of ranges.  
Using a sparse list allows to significantly reduce the amount of data storage.  
The performance of data access operations is determined by the speed of binary search.

Possible applications are handling Unicode data in converters, matchers, parsers, validators, etc.

## Sparse list example

```dart
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

final _list = SparseList(_data, Letter.unknown, length: 0x10ffff);

void _test(int c) {
  final kind = _list[c];
  print('$c: $kind');
}

enum Letter { lowerCase, number, unknown, upperCase }

```

Output:

```
32: Letter.unknown
48: Letter.number
73: Letter.upperCase
100: Letter.lowerCase
320: Letter.unknown
1114111: Letter.unknown
```