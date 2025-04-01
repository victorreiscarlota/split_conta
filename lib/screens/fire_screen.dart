import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:split_conta/providers/session_provider.dart';

class FireScreen extends StatelessWidget {
  const FireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bills = context.watch<SessionProvider>().bills;

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: bills.isEmpty
          ? const Center(child: Text('Nenhuma conta salva ainda!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bills.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(bills[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(bills[index].date)),
                      Text('Total: R\$${bills[index].totalWithTip.toStringAsFixed(2)}'),
                      Text('Pessoas: ${bills[index].people}'),
                      Text('Gorjeta: ${bills[index].tip}%'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}