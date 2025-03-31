import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/input_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _resetFields() {
    setState(() {
      _totalController.clear();
      _peopleController.clear();
      _tipController.clear();
      _tipAmount = 0;
      _totalPerPerson = 0;
      _totalWithTip = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisor de Contas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Calcular',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            if (_totalWithTip > 0)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _ResultItem(
                      label: 'Gorjeta do Garçom',
                      value: _tipAmount,
                    ),
                    const Divider(height: 30),
                    _ResultItem(
                      label: 'Total por Pessoa',
                      value: _totalPerPerson,
                    ),
                    const Divider(height: 30),
                    _ResultItem(
                      label: 'Valor Total com Gorjeta',
                      value: _totalWithTip,
                      isTotal: true,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;

  const _ResultItem({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey[700],
          ),
        ),
        Text(
          'R\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}