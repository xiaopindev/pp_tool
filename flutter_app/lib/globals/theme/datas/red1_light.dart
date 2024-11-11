part of '../theme_datas.dart';

final ThemeData _red1Light = ThemeData(
  useMaterial3: true,
  primaryColor: const Color(0xFFEF3E6E), // 较浅的红色
  scaffoldBackgroundColor: const Color(0xFFFFFFFF), // 白色背景
  shadowColor: const Color(0xFF2C2C2C),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFFEF3E6E), // 较浅的红色
    secondary: Colors.tealAccent, // 白色背景
    surface: const Color(0xFFF5F5F5), // 浅灰色背景
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: const Color(0xFF757575),
    onError: Colors.red,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFEF3E6E), // 背景颜色
    foregroundColor: Colors.white, // 前景颜色（文字、图标等）
    elevation: 4, // 阴影高度
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ), // 标题文本样式
    iconTheme: IconThemeData(
      color: Colors.white,
    ), // 图标样式
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFEF3E6E), // 高亮背景色
    disabledColor: Color(0xFFBDBDBD), // 禁用背景色
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFFBDBDBD); // 禁用背景色
          }
          return const Color(0xFFEF3E6E); // 高亮背景色
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFFFFFFFF); // 禁用字体色
          }
          return const Color(0xFFFFFFFF); // 高亮字体色
        },
      ),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: const Color(0xFFF5F5F5), // 背景颜色
    textStyle: const TextStyle(color: Colors.black), // 文本样式
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ), // 圆角
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFEF3E6E), // 进度条颜色
    linearTrackColor: Color(0xFFBDBDBD), // 进度条背景颜色
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFFFFF), // 背景颜色
    selectedItemColor: Color(0xFFEF3E6E), // 选中项颜色
    unselectedItemColor: Color(0xFF757575), // 未选中项颜色
    selectedIconTheme: IconThemeData(color: Color(0xFFEF3E6E)), // 选中项图标颜色
    unselectedIconTheme: IconThemeData(color: Color(0xFF757575)), // 未选中项图标颜色
    selectedLabelStyle:
        TextStyle(fontSize: 15, fontWeight: FontWeight.w500), // 选中项标签样式
    unselectedLabelStyle:
        TextStyle(fontSize: 13, fontWeight: FontWeight.normal), // 未选中项标签样式
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFF000000)), // 标题色
    displayMedium: TextStyle(color: Color(0xFF000000)), // 标题色
    displaySmall: TextStyle(color: Color(0xFF000000)), // 标题色
    headlineLarge: TextStyle(color: Color(0xFF000000)), // 标题色
    headlineMedium: TextStyle(color: Color(0xFF000000)), // 标题色
    headlineSmall: TextStyle(color: Color(0xFF000000)), // 标题色
    titleLarge: TextStyle(color: Color(0xFF000000)), // 标题色
    titleMedium: TextStyle(color: Color(0xFF757575)), // 副标题色
    titleSmall: TextStyle(color: Color(0xFF757575)), // 副标题色
    bodyLarge: TextStyle(color: Color(0xFF757575)), // 正文色
    bodyMedium: TextStyle(color: Color(0xFF757575)), // 正文色
    bodySmall: TextStyle(color: Color(0xFF757575)), // 正文色
    labelLarge: TextStyle(color: Color(0xFF757575)), // 标签色
    labelMedium: TextStyle(color: Color(0xFF757575)), // 标签色
    labelSmall: TextStyle(color: Color(0xFF757575)), // 标签色
  ),
  cardTheme: const CardTheme(
    color: Color(0xFFFFFFFF), // 卡片背景颜色
    shadowColor: Color(0xFFEFEAEA), // 阴影颜色
    elevation: 1, // 阴影高度
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6), // 外边距
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)), // 圆角
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFEDE8E8), // 分割线颜色
    thickness: 0.5, // 分割线厚度
    indent: 15, // 分割线起始位置的缩进
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Color(0xFFFFFFFF), // 列表项背景颜色
    selectedColor: Color(0xFFEF3E6E), // 选中项颜色
    iconColor: Color(0xFF757575), // 图标颜色
    textColor: Color(0xFF757575), // 文本颜色
    selectedTileColor: Color(0xFFFFCDD2), // 选中项背景颜色
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // 内容内边距
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF5F5F5), // 填充颜色
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)), // 圆角
      borderSide: BorderSide.none, // 无边框
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)), // 圆角
      borderSide: BorderSide(color: Color(0xFF757575)), // 启用状态下的边框颜色
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)), // 圆角
      borderSide: BorderSide(color: Color(0xFFEF3E6E)), // 聚焦状态下的边框颜色
    ),
    hintStyle: TextStyle(color: Color(0xFF757575)), // 提示文本样式
    labelStyle: TextStyle(color: Color(0xFF757575)), // 标签文本样式
    counterStyle: TextStyle(color: Color(0xFF757575)), // 字符计数器样式
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFFFFFFF), // 底部弹出框背景颜色
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // 圆角
    ),
  ),
);
