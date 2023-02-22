import 'package:flutter/material.dart';
import 'package:munchkin_counter/shared/colors.dart';

class MyPageSelector extends StatelessWidget {
  Function updateState;
  MyPageSelector(this.updateState);

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/treasure_transparent.png"),
                ),
                Text(
                  "This app will help you to play Munchkin without being distracted from the game",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
      Center(
          child: Text(
        "You can save your games, count levels,battle with monsters, change hero position",
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      )),
      Container(
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Text(
                "Tap \"Start\" to start playing \n\nEnjoy your game",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            )),
            //Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(brownColor)),
              onPressed: () {
                updateState();
              },
              child: Text(
                "Start",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ];
    return DefaultTabController(
      length: pages.length,
      child: Builder(builder: (context) {
        final TabController controller = DefaultTabController.of(context);
        return Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(children: pages),
              ),
              TabPageSelector(
                color: lightOrange,
                selectedColor: brownColor,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (!controller.indexIsChanging) {
                          controller.animateTo(pages.length - 1);
                        }
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(color: brownColor),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(brownColor)),
                      onPressed: () {
                        if (controller.index != pages.length - 1) {
                          controller.animateTo(controller.index + 1);
                        }
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
