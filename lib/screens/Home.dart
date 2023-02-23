import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munchkin_counter/screens/GameScreen.dart';
import 'package:munchkin_counter/services/SPService.dart';
import 'package:munchkin_counter/shared/colors.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 1,
      minLaunches: 2,
      remindDays: 2,
      remindLaunches: 2,
      appStoreIdentifier: 'com.alexpan.munchkinCounter',
      googlePlayIdentifier: 'com.alexpan.munchkin_counter');

  @override
  void initState() {
    super.initState();
    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showStarRateDialog(
          context,
          title: "Enjoying Munchkin Level Counter?".tr(),
          message: "Please leave a rating!".tr(),
          dialogStyle: const DialogStyle(
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20),
          ),
          actionsBuilder: (context, stars) {
            return [
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  await _rateMyApp
                      .callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(
                      context, RateMyAppDialogButton.rate);
                  _rateMyApp.launchStore();
                },
              ),
            ];
          },
          starRatingOptions: StarRatingOptions(),
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  List<String> companies;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        initialData: [""],
        future: SPService.getCompanies(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          return (snapshot.data == null || snapshot.data.length == 0)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "You dont have any games now \n Tap \" + \" to add new"
                          .tr(),
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : GridView.count(
                  padding: EdgeInsets.all(16),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  crossAxisCount: 2,
                  children: [
                    for (var i = 0; i < snapshot.data.length; i++)
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GameScreen(snapshot.data[i])));
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(1, 2),
                                      ),
                                    ]),
                                child: Card(
                                  color: brownColor.shade600,
                                  child: Stack(children: [
                                    Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Text(
                                          snapshot.data[i],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Image.asset(
                                        'assets/images/roundtable.png',
                                        //scale: 1,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () async {
                                      bool delete =
                                          await showAlertDialog(context);
                                      if (delete != null && delete) {
                                        var isOk =
                                            await SPService.deleteCompany(
                                                snapshot.data[i]);
                                        if (isOk) {
                                          setState(() {});
                                        }
                                      }
                                    }),
                              ),
                            ],
                          ))
                  ],
                );
        },
      ),
    );
  }

  Future<bool> showAlertDialog(BuildContext context) async {
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
      child: Text("Delete".tr()),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: lightOrange,
      title: Text("Are you sure?".tr()),
      content: Text("Would you like delete to this party?".tr()),
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
}
