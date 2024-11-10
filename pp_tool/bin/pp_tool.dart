import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';

void main(List<String> arguments) {
  //print('arguments: $arguments');
  final parser = ArgParser()
    ..addCommand(
        'create',
        ArgParser()
          ..addFlag('flutter',
              abbr: 'f', negatable: false, help: 'Create a Flutter project'));

  ArgResults argResults = parser.parse(arguments);
  if (argResults.command?.name == 'create') {
    if (argResults.command!['flutter']) {
      if (argResults.command!.rest.isEmpty) {
        print('Please provide a project name: pp create -f <project_name>');
        exit(1);
      }
      String projectName = argResults.command!.rest[0];
      print('$projectName flutter project generating...');
      createFlutterProjectFromZip(projectName);
    } else {
      print('Invalid command or option.');
    }
  } else {
    print('Usage: pp create -f <project_name>');
  }
}

void createFlutterProjectFromZip(String projectName) {
  String? templateZipPath = Platform.environment['FLUTTER_TEMPLATE_PATH'];
  if (templateZipPath == null || templateZipPath.isEmpty) {
    print('Error: FLUTTER_TEMPLATE_PATH environment variable is not set.');
    exit(1);
  }
  print('Template source file: $templateZipPath');
  String destinationPath = Directory.current.path;
  print('Target directory: $destinationPath');

  if (!Directory(destinationPath).existsSync()) {
    print('Error: $destinationPath not exists.');
    exit(1);
  }

  File zipFile = File(templateZipPath);
  if (!zipFile.existsSync()) {
    print('Error: Template zip file not found at $templateZipPath');
    exit(1);
  }

  List<int> bytes = zipFile.readAsBytesSync();
  Archive archive = ZipDecoder().decodeBytes(bytes);

  for (ArchiveFile file in archive) {
    if (file.name.contains('__MACOSX') || file.name.contains('DS_Store')) {
      continue;
    }

    String filePath = path.join(destinationPath, file.name);

    if (file.isFile) {
      //print('File: $filePath');
      // 检查文件扩展名
      String fileExtension = path.extension(file.name);
      Set<String> textFileExtensions = {
        '.dart',
        '.yaml',
        '.json',
        '.txt',
        '.md',
        '.html',
        '.xml',
        '.gradle',
        '.kt',
        '.cc',
        '.rc',
        '.cpp',
        '.plist',
        '.xcconfig',
        '.xcscheme',
        '.pbxproj'
      };
      if (textFileExtensions.contains(fileExtension)) {
        List<int> content = file.content as List<int>;
        String fileContent = String.fromCharCodes(content);
        fileContent = fileContent.replaceAll('flutter_app', projectName);

        File(filePath)
          ..createSync(recursive: true)
          ..writeAsStringSync(fileContent);
      } else {
        // 对于非文本文件，直接写入字节
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      }
    } else {
      //print('Directory: $filePath');
      Directory(filePath).createSync(recursive: true);
    }
  }
  renameFiles(destinationPath, projectName);
  renameDirectories(destinationPath, projectName);
  print(
      'Flutter project "$projectName" created successfully at $destinationPath/$projectName');
}

void renameFiles(String directoryPath, String projectName) {
  Directory directory = Directory(directoryPath);
  for (FileSystemEntity entity in directory.listSync(recursive: true)) {
    if (entity is File) {
      String dirPath = path.dirname(entity.path);
      String fileName = path.basename(entity.path);
      if (!fileName.contains('flutter_app')) {
        continue;
      }
      String newFileName = fileName.replaceAll('flutter_app', projectName);
      String newPath = path.join(dirPath, newFileName);
      try {
        entity.renameSync(newPath);
        //print('Renamed file: ${entity.path} to $newPath');
      } catch (e) {
        print('ERROR: Failed to rename ${entity.path}: $e');
      }
    }
  }
}

void renameDirectories(String directoryPath, String projectName) {
  Directory directory = Directory(directoryPath);

  for (FileSystemEntity entity in directory.listSync()) {
    if (entity is Directory) {
      renameDirectories(entity.path, projectName);
    }
  }

  for (FileSystemEntity entity in directory.listSync()) {
    if (entity is Directory) {
      String parentDirPath = path.dirname(entity.path);
      String dirName = path.basename(entity.path);
      if (!dirName.contains('flutter_app')) {
        continue;
      }
      String newDirName = dirName.replaceAll('flutter_app', projectName);
      String newPath = path.join(parentDirPath, newDirName);

      try {
        entity.renameSync(newPath);
        //print('Renamed directory: ${entity.path} to $newPath');
      } catch (e) {
        print('ERROR: Failed to rename ${entity.path}: $e');
      }
    }
  }
}
