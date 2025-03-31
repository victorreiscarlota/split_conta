import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/input_field.dart';

class BillSplitterScreen extends StatefulWidget {
  const BillSplitterScreen({super.key});

  @override
  State<BillSplitterScreen> createState() => _BillSplitterScreenState();
}

class _BillSplitterScreenState extends State<BillSplitterScreen> {
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();

  double _tipAmount = 0;
  double _totalPerPerson = 0;
  double _totalWithTip = 0;

  void _calculate() {
    if (_totalController.text.isEmpty ||
        _peopleController.text.isEmpty ||
        _tipController.text.isEmpty) return;

    final double total = double.parse(_totalController.text);
    final int people = int.parse(_peopleController.text);
    final double tipPercentage = double.parse(_tipController.text);

    setState(() {
      _tipAmount = total * (tipPercentage / 100);
      _totalWithTip = total + _tipAmount;
      _totalPerPerson = _totalWithTip / people;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisor de Contas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InputField(
              controller: _totalController,
              label: 'Valor Total (R\$)',
              icon: Icons.attach_money,
              inputType: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _peopleController,
              label: 'Número de Pessoas',
              icon: Icons.people,
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            InputField(
              controller: _tipController,
              label: 'Gorjeta (%)',
              icon: Icons.percent,
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 30),
            if (_totalWithTip > 0)
              Column(
                children: [
                  Text(
                    'Gorjeta: R\$${_tipAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Total por pessoa: R\$${_totalPerPerson.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Total com gorjeta: R\$${_totalWithTip.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}