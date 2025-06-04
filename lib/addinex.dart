import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddIncomeExpense extends StatelessWidget {
  const AddIncomeExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF321B15),
        title: Center(
          child: const Text(
            'Add Income or Expense',
            style: TextStyle(
              color: Color.fromARGB(255, 221, 214, 199),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: Column(children: [AddIE()]),
    );
  }
}

class AddIE extends StatefulWidget {
  const AddIE({super.key});

  @override
  State<AddIE> createState() => _AddIEState();
}

class _AddIEState extends State<AddIE> {
  final amountController = TextEditingController();
  final categoryController = TextEditingController();

  final firebase = FirebaseFirestore.instance;
  int selectedIndex = -1;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> addIncomeOrExpenseToFirebase(
    double? amount,
    String category,
    String titleType,
  ) async{
    firebase.collection('users').doc(uid).collection('transactions').add({
      'title': titleType,
      'amount': amount,
      'category': category,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  changeIndex(0);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedIndex == 0 ? Color(0XFF321B15) : Color(0XFFECE5D8),
                foregroundColor:
                    selectedIndex == 0 ? Color(0XFFECE5D8) : Color(0XFF321B15),
              ),
              child: Text("Income"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  changeIndex(1);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedIndex == 1 ? Color(0XFF321B15) : Color(0XFFECE5D8),
                foregroundColor:
                    selectedIndex == 1 ? Color(0XFFECE5D8) : Color(0XFF321B15),
              ),
              child: Text("Expense"),
            ),
          ],
        ),
        SizedBox(height: 20),
        Divider(
          thickness: 2,
          color: Color(0XFF321B15),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Add Amount",
              contentPadding: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: TextField(
            controller: categoryController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Enter Category",
              contentPadding: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Divider(
          thickness: 2,
          color: Color(0XFF321B15),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var amount = double.tryParse(amountController.text);
                final rawCategory = categoryController.text;
                final category = capitalize(rawCategory);
            
            
                if (amount != null && category.isNotEmpty && selectedIndex != -1) {
                  try {
                    if (selectedIndex == 0) {
                      amount = amount.abs(); // make sure it's negative
                    } else {
                      amount = -amount.abs(); // income stays positive
                    }
                    await addIncomeOrExpenseToFirebase(
                      amount,
                      category,
                      selectedIndex == 0 ? "Income" : "Expense",
                    );
            
                    // Clear all fields
                    amountController.clear();
                    categoryController.clear();
                    setState(() {
                      selectedIndex = -1; // reset the selected index
                    });
            
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transaction added successfully!')),
                    );
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add transaction. Please try again.')),
                    );
                  }
                } else {
                  // Show validation error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields correctly.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0XFFECE5D8),
                backgroundColor: Color(0XFF321B15),
              ),
              child: Text("Add Transaction"),
            ),
            SizedBox(width: 5,),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, "/homepage");
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0XFFECE5D8),
                backgroundColor: Color(0XFF321B15),
              ),
              child: Text("Back to Home Page"),
            ),
          ],
        ),

      ],
    );
  }
}
