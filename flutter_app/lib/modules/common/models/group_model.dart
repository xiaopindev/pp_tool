class GroupModel {
  String? icon;
  final String name;
  final List<GroupSubModel> items;

  GroupModel({
    this.icon,
    required this.name,
    required this.items,
  });
}

class GroupSubModel {
  int id;
  String? icon;
  String title;
  String? subTitle;

  GroupSubModel({
    required this.id,
    this.icon,
    required this.title,
    this.subTitle,
  });
}
