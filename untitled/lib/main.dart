// main.dart
import 'package:flutter/material.dart';
import 'scanner_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Scanner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BudgetPage(),
    );
  }
}

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double budget = 0.0;
  double totalSpent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Spent: \$${totalSpent.toStringAsFixed(2)}',
              style: TextStyle(
                color: budgetExceeded() ? Colors.red : budgetNearExceeded() ? Colors.yellow : Colors.green,
                fontSize: 20,
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Budget'),
              onChanged: (value) {
                setState(() {
                  budget = double.parse(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScannerPage(
                      budget: budget,
                      onUpdateTotal: (double updatedTotal) {
                        setState(() {
                          totalSpent = updatedTotal;
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Go to Scanner'),
            ),
          ],
        ),
      ),
    );
  }

  bool budgetExceeded() {
    return totalSpent > budget;
  }

  bool budgetNearExceeded() {
    return totalSpent > budget * 0.8; // Adjust the threshold as needed
  }
}
