import 'package:flutter/material.dart';
import 'package:munchkin_counter/screens/Home.dart';
import 'package:munchkin_counter/services/SPService.dart';
import 'package:munchkin_counter/shared/colors.dart';
import 'package:munchkin_counter/widgets/PageSelector.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBody();
  }
}

class MyBody extends StatefulWidget {
  MyBody({Key key}) : super(key: key);

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  bool isFirstStart;
  @override
  void initState() {
    super.initState();
    checkFirstStart();
  }

  void checkFirstStart() async {
    isFirstStart = await SPService.isFirstStart();
  }

  @override
  Widget build(BuildContext context) {
    void updateState() {
      SPService.initFirstAppStart();

      setState(() {
        isFirstStart = false;
      });
    }

    //SPService.initFirstAppStart();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          primaryColor: brownColor, scaffoldBackgroundColor: lightOrange),
      home: FutureBuilder(
        future: SPService.isFirstStart(),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Scaffold(
            appBar: snapshot.data
                ? null
                : AppBar(
                    title: Text("Munchkin counter"),
                  ),
            body: snapshot.data ? MyPageSelector(updateState) : HomeScreen(),
            floatingActionButton: snapshot.data
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            String companyName = "";
                            return Dialog(
                              child: Container(
                                color: lightOrange,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          maxLength: 12,
                                          decoration: InputDecoration(
                                              hintText: "Write company name"),
                                          onChanged: (value) {
                                            companyName = value;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          child: RaisedButton(
                                            color: brownColor,
                                            onPressed: () async {
                                              await SPService.addCompany(
                                                  companyName);
                                              setState(() {});
                                              Navigator.pop(context);
                                              //
                                              //Write to SP
                                              //
                                            },
                                            child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Icon(Icons.add),
                  ),
          );
        },
      ),
    );
  }
}
