# pp_tool介绍

每个人都会有自己的一套技术体系和工程模版，在开发下一个项目的时候希望能够快速的生成和配置好基础的项目工程。就类似于新建一个项目工程，可以选择空项目工程，也可以选择模版工程。

我们是不是也可以通过一个命令，自动生成自己的工程模版？

比如命令终端中输入：

``` bash
pp create -f my_flutter_project
pp create -i my_ios_project
pp create -h my_harmoney_project
pp create -a my_android_project
pp create -w my_web_project

pp create -f my_app -o ppsw
```

# 命令说明

``` bash
xiaopin@PPM2-MacBook-Air Samples % pp help
arguments: [help]
pp_tool help:
  Usage:
  pp create -f <project_name> [-o <organization_name>]
  -f <project_name>: The name of the Flutter project to create.
  -o <organization_name>: The organization name for the project. Defaults to 'example'.

  pp -v : Show the version of the tool
```

# 使用说明

- 下载激活使用

打开终端（macOS/Linux）或命令提示符（Windows），然后运行以下命令来全局安装 pp_tool：

``` bash
dart pub global activate pp_tool
```

这将从 pub.dev 下载并安装 pp_tool，并将其添加到你的 Dart 全局工具中。

- 将模板路径存放到环境变量

将模板路径存放到环境变量，确保你的自定义命令能够自动读取该路径。

**在操作系统中设置环境变量**：

**Windows**：在系统设置中，设置一个名为 FLUTTER_TEMPLATE_PATH 的环境变量，值为模板的绝对路径。

**macOS/Linux**：在 ~/.bashrc 或 ~/.zshrc 中添加以下行：

``` bash
export FLUTTER_TEMPLATE_PATH="/Users/xiaopin/dev/templates/flutter_app.zip"
```

我添加的环境变量是：

``` bash
export PATH=/Users/xiaopin/dev/flutter/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export FLUTTER_TEMPLATE_PATH="/Users/xiaopin/dev/templates/flutter_app.zip"
```

如果你不在中国，可以去掉：

``` bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

然后运行 source ~/.bashrc 或 source ~/.zshrc ，或者重新启动终端命令，以使更改生效。

``` bash
source ~/.zshrc
```

- 运行命令

```bash
pp create -f hello_app -o ppsw
```

- 查看结果

```
xiaopin@PPM2-MacBook-Air Samples % pp create -f hello_app -o ppsw
arguments: [create, -f, hello_app, -o, ppsw]
Organization: ppsw
Project: hello_app
hello_app flutter project generating...
Template source file: /Users/xiaopin/dev/templates/flutter_app.zip
Target directory path: /Users/xiaopin/Desktop/AppDev/Flutter/Samples
Flutter project "hello_app" created successfully at /Users/xiaopin/Desktop/AppDev/Flutter/Samples/hello_app
Done!
```
