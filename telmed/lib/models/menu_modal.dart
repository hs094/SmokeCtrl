class MenuModel {
  String icon;
  String title;
  MenuModel({required this.icon, required this.title});
}

List<MenuModel> menu_dark = [
  MenuModel(icon: 'assets/svg/home_grey.svg', title: "Dashboard"),
  MenuModel(icon: 'assets/svg/remote_grey.svg', title: "User Database"),
  MenuModel(icon: 'assets/svg/bell_grey.svg', title: "Notification"),
  MenuModel(icon: 'assets/svg/history_grey.svg', title: "History"),
  MenuModel(icon: 'assets/svg/setting_grey.svg', title: "Settings"),
  MenuModel(icon: 'assets/svg/logout_grey.svg', title: "Sign Out"),
];

List<MenuModel> menu_light = [
  MenuModel(icon: 'assets/svg/home_black.svg', title: "Dashboard"),
  MenuModel(icon: 'assets/svg/remote_black.svg', title: "User Database"),
  MenuModel(icon: 'assets/svg/bell_black.svg', title: "Notification"),
  MenuModel(icon: 'assets/svg/history_black.svg', title: "History"),
  MenuModel(icon: 'assets/svg/setting_black.svg', title: "Settings"),
  MenuModel(icon: 'assets/svg/logout_black.svg', title: "Sign Out"),
];
