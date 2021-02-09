class MyPlayer {
  int id;
  String name;
  String gameName;
  int level;
  int stuff;
  int sex;
  int color;
  bool isDoubleHero;

  MyPlayer(
      {this.id,
      this.name,
      this.level,
      this.stuff,
      this.sex,
      this.color,
      this.isDoubleHero,
      this.gameName});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      '"id"': id,
      '"name"': name,
      '"level"': level,
      '"stuff"': stuff,
      '"sex"': sex,
      '"color"': color,
      '"gameName"': gameName,
    };
    return map;
  }
}
