import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FireBill {
  final String name;
  final DateTime date;
  final double total;
  final int people;
  final double tip;
  final double totalWithTip;

  FireBill({
    required this.name,
    required this.date,
    required this.total,
    required this.people,
    required this.tip,
    required this.totalWithTip,
  });
}

class SessionProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  XFile? _photo;
  final List<FireBill> _bills = [];

  String? get name => _name;
  String? get email => _email;
  XFile? get photo => _photo;
  List<FireBill> get bills => _bills;

  void updateProfile(String name, String email, XFile? photo) {
    _name = name;
    _email = email;
    _photo = photo;
    notifyListeners();
  }

  void addBill(FireBill bill) {
    _bills.add(bill);
    notifyListeners();
  }
}