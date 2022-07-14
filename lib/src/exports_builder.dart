import 'package:auto_exporter/src/exporter_generator_builder.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// the ExportsBuilder will create the file to
/// export all dart files
class ExportsBuilder implements Builder {
  static var packageName = '';
  static const generatedFileName = 'exports.dart';

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$lib$': [generatedFileName]
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final exports = buildStep
        .findAssets(Glob('**/*${ExporterGeneratorBuilder.exportExtension}'));
    final expList = <String>[];
    final content = ["//! AUTO GENERATE FILE, DONT MODIFY!!"];
    await for (final exportLibrary in exports) {
      final exportUri = exportLibrary.changeExtension('.dart').uri;
      if (exportUri.toString().substring(0, 5) != "asset") {
        if (exportUri.toString() != 'package:$packageName/$packageName.dart') {
          final expStr = getExportString(exportUri);
          expList.add(expStr);
        }
      }
    }

    content.addAll(expList);
    content.insert(0, '// $packageName');
    if (content.isNotEmpty) {
      await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, 'lib/$generatedFileName'),
          content.join('\n'));
    }
    print('[AUTO_EXPORTER] add to your library main file $packageName.dart'
        '\n'
        'export \'package:$packageName/exports.dart\';');
  }

  String getExportString(Uri exportUri) {
    final expStr = "export '$exportUri'${getHiddenClass(exportUri)};";
    return expStr;
  }

  String getHiddenClass(Uri exportUri) {
    final hiddenElements = ExporterGeneratorBuilder.hiddenElements;
    final Set<String> hiddenClasses = {};
    for (final hiddenElement in hiddenElements) {
      if (hiddenElement.source?.uri == exportUri) {
        final className = hiddenElement.name;
        if (className != null) {
          hiddenClasses.add(className);
        }
      }
    }
    String result = '';
    if (hiddenClasses.isNotEmpty) {
      result = ' hide ';
      result += hiddenClasses.join(',');
    }
    return result;
  }
}
