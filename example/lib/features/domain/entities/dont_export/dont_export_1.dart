import 'package:auto_exporter/auto_exporter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@doNotExport
@freezed
class TestClass {}

class TestClass2 {}

@doNotExport
class TestClass3 {}
