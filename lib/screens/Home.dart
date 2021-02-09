import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munchkin_counter/screens/GameScreen.dart';
import 'package:munchkin_counter/services/SPService.dart';
import 'package:munchkin_counter/shared/colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/battlebackground1.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder(
        initialData: [""],
        future: SPService.getCompanies(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          return snapshot.data == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "You dont have any games now \n Tap \" + \" to add new",
                      style: TextStyle(fontSize: 24),
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
                                  color: lightOrange,
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
                                      var isOk = await SPService.deleteCompany(
                                          snapshot.data[i]);
                                      if (isOk) {
                                        setState(() {});
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
}
