import 'package:flutter/material.dart';

class Loan {
  final String id;
  final String personName;
  final double amount;
  final bool isLent; // true = prestati a un amico, false = presi in prestito
  final DateTime date;
  bool isPaid;

  Loan({
    required this.id,
    required this.personName,
    required this.amount,
    required this.isLent,
    required this.date,
    this.isPaid = false,
  });
}

class LoansPage extends StatefulWidget {
  const LoansPage({Key? key}) : super(key: key);

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  final List<Loan> _loans = [];

  void _addLoan(String name, double amount, bool isLent) {
    setState(() {
      _loans.add(Loan(
        id: DateTime.now().toString(),
        personName: name,
        amount: amount,
        isLent: isLent,
        date: DateTime.now(),
      ));
    });
  }

  void _togglePaid(int index) {
    setState(() {
      _loans[index].isPaid = !_loans[index].isPaid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prestiti e Debiti'),
      ),
      body: _loans.isEmpty
          ? const Center(child: Text('Nessun prestito registrato.'))
          : ListView.builder(
              itemCount: _loans.length,
              itemBuilder: (context, index) {
                final loan = _loans[index];
                return ListTile(
                  leading: Icon(
                    loan.isLent ? Icons.arrow_upward : Icons.arrow_downward,
                    color: loan.isLent ? Colors.orange : Colors.blue,
                  ),
                  title: Text('${loan.personName} - €${loan.amount.toStringAsFixed(2)}'),
                  subtitle: Text(
                    loan.isLent ? 'Da ricevere' : 'Da restituire',
                    style: TextStyle(
                      color: loan.isPaid ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Checkbox(
                    value: loan.isPaid,
                    onChanged: (_) => _togglePaid(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    bool isLent = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulWidget(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nuovo Prestito'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome Persona'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Importo (€)'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Ho Prestato'),
                    selected: isLent,
                    onSelected: (selected) {
                      if (selected) setDialogState(() => isLent = true);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Ho Chiesto'),
                    selected: !isLent,
                    onSelected: (selected) {
                      if (selected) setDialogState(() => isLent = false);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (name.isNotEmpty && amount > 0) {
                  _addLoan(name, amount, isLent);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }
}
