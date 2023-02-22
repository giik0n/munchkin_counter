import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:munchkin_counter/models/Player.dart';
import 'package:munchkin_counter/shared/colors.dart';
import 'package:numberpicker/numberpicker.dart';

class BattleScreen extends StatefulWidget {
  MyPlayer player;
  List<MyPlayer> allPlayers;
  Function updatePlayer;
  BattleScreen(this.player, this.allPlayers, this.updatePlayer, {Key key})
      : super(key: key);

  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  List<int> playersBonus = [];
  bool isDoubleHero = false;
  MyPlayer monster = MyPlayer(level: 0, stuff: 0, name: "Monster");
  List<Widget> stuffRange = [
    for (var i = -100; i < 100; i++) Text(i.toString())
  ];

  List<MyPlayer> players = [];
  List<MyPlayer> monsters = [];
  List<MyPlayer> allPlayers = [];

  List<FixedExtentScrollController> scrollControllerEnemysLevels = [];
  List<FixedExtentScrollController> scrollControllerEnemysStuffs = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.player = null;
  }

  @override
  Widget build(BuildContext context) {
    if (players.length == 0) {
      players.add(widget.player);
      playersBonus.add(0);
    }

    if (monsters.length == 0) {
      monsters.add(monster);
    }

    if (allPlayers.length == 0) {
      for (var i = 0; i < widget.allPlayers.length; i++) {
        allPlayers.add(widget.allPlayers[i]);
      }
    }
    allPlayers.remove(widget.player);
    int heroesPowerSum = 0;

    for (var i = 0; i < players.length; i++) {
      heroesPowerSum += players[i].isDoubleHero
          ? ((players[i].level + players[i].stuff) * 2 + playersBonus[i])
          : (players[i].level + players[i].stuff + playersBonus[i]);
    }

    int monstersPowerSum = 0;
    for (var i = 0; i < monsters.length; i++) {
      monstersPowerSum += monsters[i].level + monsters[i].stuff;
    }

    if (scrollControllerEnemysLevels.length == 0) {
      scrollControllerEnemysLevels
          .add(FixedExtentScrollController(initialItem: monsters[0].level));
    }
    if (scrollControllerEnemysStuffs.length == 0) {
      scrollControllerEnemysStuffs.add(
          FixedExtentScrollController(initialItem: monsters[0].stuff + 100));
    }
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          backgroundColor: lightOrange,
          title: Text('Warning'),
          content: Text('Do you really want to exit from the battle?'),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(brownColor),
              ),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Text('Exit'),
                onPressed: () {
                  widget.player = players[0];
                  Navigator.pop(c, true);
                }),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.player.name + "'s battle"),
          actions: [
            IconButton(
                icon: FaIcon(FontAwesomeIcons.dice),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => StatefulBuilder(
                            builder: (context, setDiceState) {
                              return GestureDetector(
                                onTap: () {
                                  setDiceState(() {});
                                },
                                child: Container(
                                  child: Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: showRandomDice(),
                                  ),
                                ),
                              );
                            },
                          ));
                })
          ],
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(
          //       "assets/images/background_hw.jpeg",
          //     ),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //player card
                  Container(
                    height: 235,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var i = 0; i < players.length; i++)
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.8),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      color: brownColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  players[i].name,
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                InkWell(
                                                  child: genderIcons[
                                                      players[i].sex],
                                                  onTap: () {
                                                    setState(() {
                                                      if (players[i].sex == 0) {
                                                        players[i].sex = 1;
                                                        widget.updatePlayer(
                                                            widget.allPlayers
                                                                .indexOf(
                                                                    players[i]),
                                                            players[i]);
                                                      } else {
                                                        players[i].sex = 0;
                                                      }
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
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
                                                              onPressed: () {
                                                                setState(() {
                                                                  players[i]
                                                                      .level++;
                                                                });
                                                              },
                                                              icon: Icon(
                                                                  Icons.add)),
                                                          Text(
                                                            players[i]
                                                                .level
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 24),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  players[i]
                                                                      .level--;
                                                                });
                                                              },
                                                              icon: Icon(Icons
                                                                  .remove)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 24,
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
                                                              onPressed: () {
                                                                setState(() {
                                                                  players[i]
                                                                      .stuff++;
                                                                });
                                                              },
                                                              icon: Icon(
                                                                  Icons.add)),
                                                          Text(
                                                            players[i]
                                                                .stuff
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 24),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  players[i]
                                                                      .stuff--;
                                                                });
                                                              },
                                                              icon: Icon(Icons
                                                                  .remove)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star_outline),
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  playersBonus[
                                                                      i]++;
                                                                });
                                                              },
                                                              icon: Icon(
                                                                  Icons.add)),
                                                          Text(
                                                            playersBonus[i]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 24),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  playersBonus[
                                                                      i]--;
                                                                });
                                                              },
                                                              icon: Icon(Icons
                                                                  .remove)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            players.length <= 1
                                                ? Row(
                                                    children: [
                                                      IconButton(
                                                        icon: Image.asset(
                                                          "assets/images/doublepersons.png",
                                                          color: players[i]
                                                                  .isDoubleHero
                                                              ? lightOrange
                                                              : Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            players[i]
                                                                    .isDoubleHero =
                                                                !players[i]
                                                                    .isDoubleHero;
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  (players.length < 2 &&
                                          players[0].isDoubleHero == false)
                                      ? Positioned(
                                          bottom: 0,
                                          right: 10,
                                          child: FloatingActionButton(
                                            heroTag: null,
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        lightOrange,
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      children: [
                                                        for (var i = 0;
                                                            i <
                                                                allPlayers
                                                                    .length;
                                                            i++)
                                                          InkWell(
                                                            onTap: () {
                                                              players.add(
                                                                  allPlayers[
                                                                      i]);
                                                              playersBonus
                                                                  .add(0);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Card(
                                                              color: playerColors[
                                                                  allPlayers[i]
                                                                      .color],
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                  color: playerColors[
                                                                      allPlayers[
                                                                              i]
                                                                          .color],
                                                                  height: 50,
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                            allPlayers[i].name),
                                                                      ),
                                                                      Spacer(),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_upward,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(allPlayers[i]
                                                                            .level
                                                                            .toString()),
                                                                      ),
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/swordicon.png",
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(allPlayers[i]
                                                                            .stuff
                                                                            .toString()),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          (allPlayers[i].level + allPlayers[i].stuff)
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 24,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                              setState(() {});
                                            },
                                            child: Icon(Icons.person_add),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 20,
                                        ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            heroesPowerSum.toString(),
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(290 / 360),
                            child: Container(
                              height: 3,
                              width: 45,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            monstersPowerSum.toString(),
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //enemy card
                  Stack(
                    children: [
                      Container(
                        height: 260,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var i = 0; i < monsters.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Center(
                                  child: Container(
                                    height: 220,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.8),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: Offset(1, 3),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      color: brownColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(null),
                                                    onPressed: null,
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    monsters[i].name + " ",
                                                    style:
                                                        TextStyle(fontSize: 32),
                                                  ),
                                                  Text(
                                                    (monsters[i].level +
                                                            monsters[i].stuff)
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        setState(() {
                                                          monsters.removeAt(i);
                                                        });
                                                      })
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.arrow_upward,
                                                        size: 32,
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      monsters[
                                                                              i]
                                                                          .level++;
                                                                    });
                                                                    // if (scrollControllerEnemyLevel) {

                                                                    // }
                                                                    scrollControllerEnemysLevels[i].animateTo(
                                                                        monsters[i].level.roundToDouble() *
                                                                            30,
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                200),
                                                                        curve: Curves
                                                                            .bounceIn);
                                                                  },
                                                                  icon: Text(
                                                                    "+1",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      monsters[
                                                                              i]
                                                                          .level += 5;
                                                                    });

                                                                    scrollControllerEnemysLevels[i].animateTo(
                                                                        monsters[i].level.roundToDouble() *
                                                                            30,
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                200),
                                                                        curve: Curves
                                                                            .bounceIn);
                                                                  },
                                                                  icon: Text(
                                                                    "+5",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                                height: 50,
                                                                width: 50,
                                                                child:
                                                                    CupertinoPicker(
                                                                  itemExtent:
                                                                      30,
                                                                  scrollController:
                                                                      scrollControllerEnemysLevels[
                                                                          i],
                                                                  onSelectedItemChanged:
                                                                      (int
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      monsters[i]
                                                                              .level =
                                                                          value;
                                                                    });
                                                                  },
                                                                  children: [
                                                                    for (var i =
                                                                            0;
                                                                        i < 100;
                                                                        i++)
                                                                      Text(i
                                                                          .toString())
                                                                  ],
                                                                )),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (monsters[i]
                                                                            .level >
                                                                        0) {
                                                                      setState(
                                                                          () {
                                                                        monsters[i]
                                                                            .level--;
                                                                      });
                                                                      scrollControllerEnemysLevels[i].animateTo(
                                                                          monsters[i].level.roundToDouble() *
                                                                              30,
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  200),
                                                                          curve:
                                                                              Curves.bounceIn);
                                                                    }
                                                                  },
                                                                  icon: Text(
                                                                    "-1",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (monsters[i]
                                                                            .level >
                                                                        0) {
                                                                      setState(
                                                                          () {
                                                                        monsters[i]
                                                                            .level -= 5;
                                                                      });

                                                                      scrollControllerEnemysLevels[i].animateTo(
                                                                          monsters[i].level -
                                                                              5.roundToDouble() *
                                                                                  30,
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  200),
                                                                          curve:
                                                                              Curves.bounceIn);
                                                                    }
                                                                  },
                                                                  icon: Text(
                                                                    "-5",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 24,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star_outline),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      monsters[
                                                                              i]
                                                                          .stuff++;
                                                                    });
                                                                    scrollControllerEnemysStuffs[i].animateTo(
                                                                        (monsters[i].stuff + 100).toDouble() *
                                                                            30,
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                200),
                                                                        curve: Curves
                                                                            .bounceIn);
                                                                  },
                                                                  icon: Text(
                                                                    "+1",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      monsters[
                                                                              i]
                                                                          .stuff += 5;
                                                                    });

                                                                    scrollControllerEnemysStuffs[i].animateTo(
                                                                        (monsters[i].stuff + 100).toDouble() *
                                                                            30,
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                200),
                                                                        curve: Curves
                                                                            .bounceIn);
                                                                  },
                                                                  icon: Text(
                                                                    "+5",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                                height: 50,
                                                                width: 50,
                                                                child:
                                                                    CupertinoPicker(
                                                                  itemExtent:
                                                                      30,
                                                                  scrollController:
                                                                      scrollControllerEnemysStuffs[
                                                                          i],
                                                                  onSelectedItemChanged:
                                                                      (int
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      monsters[i]
                                                                              .stuff =
                                                                          value -
                                                                              100;
                                                                    });
                                                                  },
                                                                  children:
                                                                      stuffRange,
                                                                )),
                                                            Row(
                                                              children: [
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      monsters[
                                                                              i]
                                                                          .stuff--;
                                                                    });
                                                                    scrollControllerEnemysStuffs[i].animateTo(
                                                                        (monsters[i].stuff + 100).toDouble() *
                                                                            30,
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                200),
                                                                        curve: Curves
                                                                            .bounceIn);
                                                                  },
                                                                  icon: Text(
                                                                    "-1",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      monsters[
                                                                              i]
                                                                          .stuff -= 5;
                                                                    });
                                                                    // if (scrollControllerEnemyLevel) {

                                                                    // }
                                                                    scrollControllerEnemysStuffs[i].animateTo(
                                                                        (monsters[i].stuff + 100).toDouble() *
                                                                            30,
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                200),
                                                                        curve: Curves
                                                                            .bounceIn);
                                                                  },
                                                                  icon: Text(
                                                                    "-5",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 1,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            MyPlayer newMonster =
                                MyPlayer(level: 0, stuff: 0, name: "Monster");
                            setState(() {
                              monsters.add(newMonster);
                              scrollControllerEnemysStuffs.add(
                                  FixedExtentScrollController(
                                      initialItem: newMonster.stuff + 100));
                              scrollControllerEnemysLevels.add(
                                  FixedExtentScrollController(
                                      initialItem: newMonster.level));
                            });
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showRandomDice() {
    int rand = 1 + Random().nextInt(7 - 1);
    return Image.asset("assets/images/$rand.png");
  }
}
