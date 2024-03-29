import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin_counter/models/Player.dart';
import 'package:munchkin_counter/screens/BattleScreen.dart';
import 'package:munchkin_counter/services/DatabaseService.dart';
import 'package:munchkin_counter/shared/colors.dart';

class GameScreen extends StatefulWidget {
  String company;

  GameScreen(this.company);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<MyPlayer> players = [];

  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerName = TextEditingController();

  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    databaseService.initDatabase();
    getLocalPlayers();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void updatePlayer(int i, MyPlayer player) async {
    setState(() {
      players[i] = player;
    });
  }

  showAddDialog() async {
    bool isAdd = false;
    MyPlayer player = MyPlayer(
        color: players.length < playerColors.length
            ? players.length
            : playerColors.length - 1,
        sex: 0,
        level: 1,
        stuff: 0,
        name: "Hero ".tr() + (players.length + 1).toString(),
        gameName: widget.company,
        isDoubleHero: false);
    _controller.text = player.name;
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              color: lightOrange,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onTap: () {
                        _controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _controller.value.text.length);
                      },
                      controller: _controller,
                      decoration:
                          InputDecoration(prefix: Text("Name".tr())),
                      onChanged: (value) {
                        player.name = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: StatefulBuilder(
                      builder: (context, setRadioState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setRadioState(() {
                                  player.sex = 0;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                      value: 0,
                                      groupValue: player.sex,
                                      onChanged: (value) {
                                        setRadioState(() {
                                          player.sex = value;
                                        });
                                      }),
                                  FaIcon(FontAwesomeIcons.venus),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Female".tr())
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setRadioState(() {
                                  player.sex = 1;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: player.sex,
                                    onChanged: (value) {
                                      setRadioState(() {
                                        player.sex = value;
                                      });
                                    },
                                  ),
                                  FaIcon(FontAwesomeIcons.mars),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Male".tr())
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Card(
                    child: Container(
                      color: lightOrange,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Select players color".tr()),
                            SizedBox(
                              height: 8,
                            ),
                            StatefulBuilder(builder: (context, setColorState) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (var i = 0; i < playerColors.length; i++)
                                    GestureDetector(
                                      onTap: () {
                                        setColorState(() {
                                          player.color = i;
                                        });
                                      },
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        color: playerColors[i],
                                        child: i == player.color
                                            ? Icon(Icons.check,
                                                color: Colors.white)
                                            : SizedBox.shrink(),
                                      ),
                                    )
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(brownColor)),
                        onPressed: () {
                          isAdd = true;
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Add".tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    return isAdd ? player : null;
  }

  Future<List<MyPlayer>> getPlayers() async {
    await databaseService.initDatabase();
    List<MyPlayer> playersL = [];
    List<Map<String, dynamic>> tmpPlayers =
        await databaseService.getbyGame(widget.company);

    tmpPlayers.forEach((element) {
      playersL.add(MyPlayer(
        id: element['id'],
        name: element['name'],
        level: element['level'],
        stuff: element['stuff'],
        sex: element['sex'],
        color: element['color'],
        isDoubleHero: false,
        gameName: element['gameName'],
      ));
    });
    return playersL;
  }

  void getLocalPlayers() async {
    players = await getPlayers();
    setState(() {});
  }

  Future<bool> showAlertDialog(BuildContext context, String text) async {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(brownColor),
      ),
      child: Text("Cancel".tr()),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      child: Text("Reset".tr()),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: lightOrange,
      title: Text("Are you sure?".tr()),
      content: Text(text),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company + " Munchkins".tr()),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () async {
              MyPlayer player = await showAddDialog();
              if (player != null) {
                var id = await databaseService.addPlayer(player);
                player.id = id;
                setState(() {
                  players.add(player);
                });
              }
            },
          ),
          IconButton(
              icon: Icon(
                Icons.refresh,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () async {
                bool reset = await showAlertDialog(context, "Would you like to reset this party?".tr());
                if (reset) {
                  for (var i = 0; i < players.length; i++) {
                    players[i].level = 1;
                    players[i].stuff = 0;
                    players[i].isDoubleHero = false;
                    databaseService.updatePlayer(players[i]);
                    setState(() {});
                  }
                }
              }),
        ],
      ),
      body: players.length > 0
          ? Container(
              child: Theme(
                data: ThemeData(canvasColor: Colors.transparent),
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      final newIdx =
                          newIndex > oldIndex ? newIndex - 1 : newIndex;
                      final MyPlayer player = players.removeAt(oldIndex);
                      players.insert(newIdx, player);
                    });
                  },
                  children: players
                      .map((item) => Padding(
                            key: Key(item.name),
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: playerColors[item.color],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.6),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                              height: 125,
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: InkWell(
                                            onTap: () async {
                                              _controllerName.text = item.name;
                                              showDialog(context: context, builder: (context)  {
                                                return Dialog(
                                                  backgroundColor: lightOrange,
                                                  child: Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            controller: _controllerName,
                                                          ),
                                                          ElevatedButton(onPressed: () async {
                                                            item.name = _controllerName.text;
                                                            var result = await databaseService
                                                                .updatePlayer(item);
                                                            if (result == 1) {
                                                              setState(() {});
                                                              Navigator.pop(context);
                                                            }
                                                          }, child: Text("Save".tr()))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                            child: Text(
                                              item.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          child: genderIcons[item.sex],
                                          onTap: () async {
                                            if (item.sex == 0) {
                                              item.sex = 1;
                                            } else {
                                              item.sex = 0;
                                            }
                                            var result = await databaseService
                                                .updatePlayer(item);
                                            if (result == 1) {
                                              setState(() {});
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward,
                                        size: 32,
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  item.level++;
                                                  var result =
                                                      await databaseService
                                                          .updatePlayer(item);
                                                  if (result == 1) {
                                                    setState(() {});
                                                  }
                                                },
                                                icon: Icon(Icons.add)),
                                            Text(
                                              item.level.toString(),
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  item.level--;
                                                  var result =
                                                      await databaseService
                                                          .updatePlayer(item);
                                                  if (result == 1) {
                                                    setState(() {});
                                                  }
                                                },
                                                icon: Icon(Icons.remove)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/swordicon.png",
                                        height: 24,
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  item.stuff++;
                                                  var result =
                                                      await databaseService
                                                          .updatePlayer(item);
                                                  if (result == 1) {
                                                    setState(() {});
                                                  }
                                                },
                                                icon: Icon(Icons.add)),
                                            Text(
                                              item.stuff.toString(),
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  item.stuff--;
                                                  var result =
                                                      await databaseService
                                                          .updatePlayer(item);
                                                  if (result == 1) {
                                                    setState(() {});
                                                  }
                                                },
                                                icon: Icon(Icons.remove)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      (item.level + item.stuff).toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () async {
                                            bool delete = await showAlertDialog(context, "Remove player?".tr());
                                            if (delete != null && delete){
                                              var result = await databaseService
                                                  .removePlayer(item.id);
                                              setState(() {
                                                if (result == 1) {
                                                  players.remove(item);
                                                }
                                              });
                                            }

                                          }),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BattleScreen(
                                                          item,
                                                          players,
                                                          updatePlayer)));
                                          databaseService.updatePlayer(item);
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/battleicon.png",
                                              scale: 28,
                                            ),
                                            Text("Battle".tr()),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage(
                  //     "assets/images/background_hw.jpeg",
                  //   ),
                  //   fit: BoxFit.cover,
                  // ),
                  ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 64,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Add new players at botom \"+\" button".tr(),
                        style: TextStyle(fontSize: 24, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
