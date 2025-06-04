import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addinex.dart';
// import 'loginpage.dart';
// import 'signuppage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF321B15),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'E-Khata App',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 221, 214, 199),
                ),
              ),
              Image.asset("2.png", width: 70),
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ShowIEData(),
              ButtonatBottom(),
            ],
          ),
        )
      );
  }
}
class ShowIEData extends StatefulWidget {
  const ShowIEData({super.key});
  @override
  State<ShowIEData> createState() => _ShowIEDataState();
}

class _ShowIEDataState extends State<ShowIEData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        children: [
          Text(
            "Income: ",
            style: TextStyle(fontSize: 20, color: Color(0xFF321B15)),
          ),
          Text(
            "Expenses: ",
            style: TextStyle(fontSize: 20, color: Color(0xFF321B15)),
          ),
        ],
      ),
    );
  }
}

class ShowTypeE extends StatefulWidget {
  const ShowTypeE({super.key});

  @override
  State<ShowTypeE> createState() => _ShowTypeEState();
}

class _ShowTypeEState extends State<ShowTypeE> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Column(
        children: [
          // list builder here
          // conditional statement : if income color = green, else red
        ],
      ),
    );
  }
}

class ButtonatBottom extends StatefulWidget {
  const ButtonatBottom({super.key});

  @override
  State<ButtonatBottom> createState() => _ButtonatBottomState();
}

class _ButtonatBottomState extends State<ButtonatBottom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddIncomeExpense()),
            );
          },
          child: Text("Add Income or Expense"),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          child: const Text("Logout"),
        ),
      ],
    );
  }
}