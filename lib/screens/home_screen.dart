import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:split_conta/providers/session_provider.dart';
import 'fire_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billNameController = TextEditingController();
  final _totalController = TextEditingController();
  final _peopleController = TextEditingController();
  final _tipController = TextEditingController();
  final _dateController = TextEditingController();
  double _tipAmount = 0;
  double _totalPerPerson = 0;
  double _totalWithTip = 0;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final total = double.parse(_totalController.text);
      final people = int.parse(_peopleController.text);
      final tipPercentage = double.parse(_tipController.text);

      setState(() {
        _tipAmount = total * (tipPercentage / 100);
        _totalWithTip = total + _tipAmount;
        _totalPerPerson = _totalWithTip / people;
      });
    }
  }

  void _saveBill() {
    if (_formKey.currentState!.validate()) {
      final bill = FireBill(
        name: _billNameController.text,
        date: DateTime.now(),
        total: double.parse(_totalController.text),
        people: int.parse(_peopleController.text),
        tip: double.parse(_tipController.text),
        totalWithTip: _totalWithTip,
      );
      
      context.read<SessionProvider>().addBill(bill);
      
      _billNameController.clear();
      _totalController.clear();
      _peopleController.clear();
      _tipController.clear();
      _dateController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta salva no histórico!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Conta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FireScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _billNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Conta',
                  prefixIcon: Icon(Icons.receipt),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Data',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _dateController.text = DateFormat('dd/MM/yyyy').format(date);
                  }
                },
                validator: (value) => value!.isEmpty ? 'Selecione a data' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _totalController,
                decoration: const InputDecoration(
                  labelText: 'Valor Total (R\$)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Insira o valor' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _peopleController,
                decoration: const InputDecoration(
                  labelText: 'Número de Pessoas',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tipController,
                decoration: const InputDecoration(
                  labelText: 'Gorjeta (%)',
                  prefixIcon: Icon(Icons.percent),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Insira a %' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'CALCULAR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              if (_totalWithTip > 0) ...[
                const SizedBox(height: 30),
                _buildResultCard(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveBill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('SALVAR CONTA'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildResultLine('Gorjeta do Garçom:', _tipAmount),
            const Divider(),
            _buildResultLine('Total por Pessoa:', _totalPerPerson),
            const Divider(),
            _buildResultLine('Valor Total com Gorjeta:', _totalWithTip),
          ],
        ),
      ),
    );
  }

  Widget _buildResultLine(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            'R\$${value.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue
            ),
          ),
        ],
      ),
    );
  }
}