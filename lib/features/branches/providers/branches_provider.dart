import 'package:flutter/foundation.dart';

// Modelo simple para sucursales. Idealmente, estaría en su propio archivo.
class Branch {
  final String id;
  final String name;
  final String address;

  Branch({required this.id, required this.name, required this.address});
}

class BranchesProvider with ChangeNotifier {
  List<Branch> _branches = [];
  bool _isLoading = false;
  String? _error;

  List<Branch> get branches => _branches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BranchesProvider() {
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulación de llamada a la API
    await Future.delayed(const Duration(seconds: 1));

    _branches = [
      Branch(id: '1', name: 'Sucursal Centro', address: 'Calle Principal 123'),
      Branch(id: '2', name: 'Sucursal Norte', address: 'Avenida Norte 456'),
    ];

    _isLoading = false;
    notifyListeners();
  }
} 