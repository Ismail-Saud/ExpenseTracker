import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF321B15),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'E-Khata App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 221, 214, 199),
              ),
            ),
            Image.asset("2.png", width: 70),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [ShowIEData(), ShowTypeE(), ButtonatBottom()]),
      ),
    );
  }
}

class ShowIEData extends StatefulWidget {
  const ShowIEData({super.key});

  @override
  State<ShowIEData> createState() => _ShowIEDataState();
}

class _ShowIEDataState extends State<ShowIEData> {
  double income = 0;
  double expenses = 0;
  double balance = 0;

  bool showTotals = false;

  @override
  void initState() {
    super.initState();
    fetchMonthlyTotals();
  }

  Future<void> fetchMonthlyTotals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .where('timestamp', isGreaterThanOrEqualTo: firstDayOfMonth)
            .get();

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      double amount = (data['amount'] ?? 0).toDouble();
      if (amount > 0) {
        totalIncome += amount;
      } else {
        totalExpenses += amount;
      }
    }

    setState(() {
      income = totalIncome;
      expenses = totalExpenses.abs();
      balance = totalIncome + totalExpenses;
      showTotals = true; // trigger UI update
    });
  }

  Future<void> fetchAlltimeTotals() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .get();

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      double amount = (data['amount'] ?? 0).toDouble();
      if (amount > 0) {
        totalIncome += amount;
      } else {
        totalExpenses += amount;
      }
    }

    setState(() {
      income = totalIncome;
      expenses = totalExpenses.abs();
      balance = totalIncome + totalExpenses;
      showTotals = true;
    });
  }

  int selectedIndex = 0;

  void changeState(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  fetchMonthlyTotals();
                  changeState(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex == 0 ? Color(0XFF321B15) : Color(0XFFECE5D8),
                  foregroundColor:
                      selectedIndex == 0 ? Color(0XFFECE5D8) : Color(0XFF321B15),
                ),
                child: Text("This Month"),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchAlltimeTotals();
                  changeState(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex == 1 ? Color(0XFF321B15) : Color(0XFFECE5D8),
                  foregroundColor:
                      selectedIndex == 1 ? Color(0XFFECE5D8) : Color(0XFF321B15),
                ),
                child: Text("All Time"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(
            thickness: 2,
            color: Color(0XFF321B15),
          ),
          SizedBox(height: 10),
          if (showTotals)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Income: Rs $income",
                  style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Expenses: Rs $expenses",
                  style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Balance: Rs $balance",
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 2,
              color: Color(0XFF321B15),
            ),
            SizedBox(height: 10),
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
  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    fetchRecentTransactions();
  }

  Future<void> fetchRecentTransactions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .limit(3)
            .get();

    setState(() {
      recentTransactions = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Recent Transactions:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        if (recentTransactions.isEmpty)
          const Text("No transactions found.")
        else
          Column(
            children: 
                recentTransactions.map((txn) {
                  final amount = (txn['amount'] ?? 0).toDouble();
                  final isIncome = amount >= 0;
                  final category = txn['category'] ?? "Unknown";
    
                  return ListTile(
                    title: Text("$category", style: TextStyle(fontSize: 16)),
                    trailing: Text(
                      "Rs $amount",
                      style: TextStyle(
                        fontSize: 16,
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 10),
          Divider(
            thickness: 2,
            color: Color(0XFF321B15),
          ),
          SizedBox(height: 10),
      ],
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
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/addie");
              },
              child: Text("Add Income or Expense"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
        SizedBox(height: 15,),
        Divider(
          thickness: 2,
          color: Color(0XFF321B15),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
