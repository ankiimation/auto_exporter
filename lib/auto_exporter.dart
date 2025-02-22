library auto_exporter;

import 'package:auto_exporter/src/exporter_generator_builder.dart';
import 'package:build/build.dart';

import 'src/exports_builder.dart';

/// return the ExporterGeneratorBuilder
Builder exporterGeneratorBuilder(BuilderOptions options) {
  return ExporterGeneratorBuilder();
}

/// return the ExportsBuilder
Builder exportsBuilder(BuilderOptions options) {
  return ExportsBuilder();
}
