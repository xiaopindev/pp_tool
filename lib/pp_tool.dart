import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('create')
    ..addFlag('flutter',
        abbr: 'f', negatable: false, help: 'Create a Flutter project');

  ArgResults argResults = parser.parse(arguments);

  if (argResults.command?.name == 'create') {
    if (argResults['flutter']) {
      if (argResults.rest.isEmpty) {
        print('Please provide a project name: pp create -f <project_name>');
        exit(1);
      }
      String projectName = argResults.rest[0];
      createFlutterProjectFromZip(projectName);
    } else {
      print('Invalid command or option.');
    }
  } else {
    print('Usage: pp create -f <project_name>');
  }
}

void createFlutterProjectFromZip(String projectName) {
  // 从环境变量中读取模板路径
  String? templateZipPath = Platform.environment['FLUTTER_TEMPLATE_PATH'];

  if (templateZipPath == null || templateZipPath.isEmpty) {
    print('Error: FLUTTER_TEMPLATE_PATH environment variable is not set.');
    exit(1);
  }

  String destinationPath = path.join(Directory.current.path, projectName);

  // 检查项目是否已存在
  if (Directory(destinationPath).existsSync()) {
    print('Error: Project "$projectName" already exists.');
    exit(1);
  }

  // 解压 zip 文件
  File zipFile = File(templateZipPath);
  if (!zipFile.existsSync()) {
    print('Error: Template zip file not found at $templateZipPath');
    exit(1);
  }

  List<int> bytes = zipFile.readAsBytesSync();
  Archive archive = ZipDecoder().decodeBytes(bytes);

  for (ArchiveFile file in archive) {
    String filePath = path.join(destinationPath, file.name);
    if (file.isFile) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(file.content as List<int>);
    } else {
      Directory(filePath).createSync(recursive: true);
    }
  }

  print(
      'Flutter project "$projectName" created successfully at $destinationPath');
}
