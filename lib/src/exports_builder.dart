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
    final exports = buildStep.findAssets(Glob('**/*.exports'));

    final expList = <String>[];
    final content = ["//! AUTO GENERATE FILE, DONT MODIFY!!"];
    await for (var exportLibrary in exports) {
      final exportUri = exportLibrary.changeExtension('.dart').uri;
      if (exportUri.toString().substring(0, 5) != "asset") {
        if (exportUri.toString() != 'package:$packageName/$packageName.dart') {
          final expStr = "export '$exportUri';";
          expList.add(expStr);

          // if (content[2] == "") {
          //   packageName = expStr.split("/")[0].split(":")[1];
          //   content[2] = "// " + packageName;
          // }
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
}
