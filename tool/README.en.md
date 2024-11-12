Docs: [中文](README.md)

# Introduction

Everyone has their own set of technical systems and engineering templates. When developing the next project, you might want to quickly generate and configure the basic project structure. Similar to creating a new project, you can choose an empty project or a template project.

Can we also automatically generate our own project template with a single command?

For example, by entering the following in the terminal:

```bash
pp create -f my_flutter_project
pp create -f my_app -o ppsw
```

**Future Expansion Considerations**

```bash
pp create -i my_ios_project
pp create -h my_harmony_project
pp create -a my_android_project
pp create -w my_web_project
```

# Instructions for Building Custom Templates

1. Use VSCode, terminal commands, or other tools to create an empty project. The name must be `flutter_app`, and the package name must be `com.example.flutter_app`.
2. Add your code to the `flutter_app` project.
3. Compress the project into `flutter_app.zip`.
4. Configure it in the environment variables.

# Command Instructions

```bash
mymac@PPM2-MacBook-Air Samples % pp help
arguments: [help]
pp_tool help:
  Usage:
  pp create -f <project_name> [-o <organization_name>]
  -f <project_name>: The name of the Flutter project to create.
  -o <organization_name>: The organization name for the project. Defaults to 'example'.

  pp -v : Show the version of the tool
```

- Quickly use your custom project template to automatically create your Flutter project.

```bash
pp create -f my_flutter_project
```

- Specify your organization as well.

```bash
pp create -f my_flutter_project -o ppsw
```

# Usage Instructions

- Download, activate, and use

Open the terminal (macOS/Linux) or command prompt (Windows), and run the following command to globally install `pp_tool`:

```bash
dart pub global activate pp_tool
```

This will download and install `pp_tool` from pub.dev and add it to your Dart global tools.

- Store the template path in an environment variable

Store the template path in an environment variable to ensure your custom command can automatically read the path.

**Set environment variables in the operating system**:

**Windows**: In system settings, set an environment variable named `FLUTTER_TEMPLATE_PATH` with the value as the absolute path of the template.

**macOS/Linux**: Add the following line to `~/.bashrc` or `~/.zshrc`:

```bash
export FLUTTER_TEMPLATE_PATH="/Users/mymac/dev/templates/flutter_app.zip"
```

The environment variables I added are:

```bash
export PATH=/Users/mymac/dev/flutter/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export FLUTTER_TEMPLATE_PATH="/Users/mymac/dev/templates/flutter_app.zip"
```

If you are not in China, you can remove:

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

Then run `source ~/.bashrc` or `source ~/.zshrc`, or restart the terminal to make the changes take effect.

```bash
source ~/.zshrc
```

- Run the command

```bash
pp create -f hello_app -o ppsw
```

- View the results

```
mymac@PPM2-MacBook-Air Samples % pp create -f hello_app -o ppsw
arguments: [create, -f, hello_app, -o, ppsw]
Organization: ppsw
Project: hello_app
hello_app flutter project generating...
Template source file: /Users/mymac/dev/templates/flutter_app.zip
Target directory path: /Users/mymac/Desktop/AppDev/Flutter/Samples
Flutter project "hello_app" created successfully at /Users/mymac/Desktop/AppDev/Flutter/Samples/hello_app
Done!
```
