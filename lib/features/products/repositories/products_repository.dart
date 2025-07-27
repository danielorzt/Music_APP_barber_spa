// lib/features/products/repositories/products_repository.dart
// import '../../../core/services/api_service.dart';
import '../models/product_model.dart';

class ProductsRepository {
  // final ApiService _apiService = ApiService();

  Future<List<Product>> getAllProducts() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Datos mock para productos
    return [
      Product(
        id: 1,
        nombreproducto: 'Aceite para Barba Premium',
        descripcion: 'Aceite hidratante para barba con aceites esenciales naturales',
        precio: 25000.0,
        stock: 50,
        imagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
        categoria: 'Cuidado Personal',
        marca: 'BarberPremium',
        activo: true,
      ),
      Product(
        id: 2,
        nombreproducto: 'Navaja de Afeitar Profesional',
        descripcion: 'Navaja de acero inoxidable para un afeitado perfecto',
        precio: 45000.0,
        stock: 25,
        imagen: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
        categoria: 'Herramientas',
        marca: 'ProShave',
        activo: true,
      ),
      Product(
        id: 3,
        nombreproducto: 'Crema de Afeitar Suave',
        descripcion: 'Crema hidratante para un afeitado suave y sin irritación',
        precio: 18000.0,
        stock: 75,
        imagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
        categoria: 'Cuidado Personal',
        marca: 'SmoothShave',
        activo: true,
      ),
      Product(
        id: 4,
        nombreproducto: 'Cepillo para Barba',
        descripcion: 'Cepillo de cerdas naturales para dar forma a la barba',
        precio: 22000.0,
        stock: 40,
        imagen: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
        categoria: 'Herramientas',
        marca: 'BeardCare',
        activo: true,
      ),
      Product(
        id: 5,
        nombreproducto: 'Aceite Esencial de Lavanda',
        descripcion: 'Aceite esencial para relajación y aromaterapia',
        precio: 35000.0,
        stock: 30,
        imagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
        categoria: 'Aromaterapia',
        marca: 'NaturalEssence',
        activo: true,
      ),
    ];
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.get('/products');
    //   return (response as List).map((json) => Product.fromJson(json)).toList();
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<Product> getProductById(int id) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Buscar en los datos mock
    final products = await getAllProducts();
    final product = products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Producto no encontrado'),
    );
    
    return product;
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.get('/products/$id');
    //   return Product.fromJson(response);
    // } catch (e) {
    //   rethrow;
    // }
  }

  // Para administradores
  Future<Product> createProduct(Product product) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Simular creación exitosa
    return Product(
      id: DateTime.now().millisecondsSinceEpoch,
      nombreproducto: product.nombreproducto,
      descripcion: product.descripcion,
      precio: product.precio,
      stock: product.stock,
      imagen: product.imagen,
      categoria: product.categoria,
      marca: product.marca,
      activo: product.activo,
    );
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.post('/products', data: product.toJson());
    //   return Product.fromJson(response);
    // } catch (e) {
    //   rethrow;
    // }
  }

  // Para administradores
  Future<Product> updateProduct(Product product) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simular actualización exitosa
    return product;
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.put('/products/${product.id}', data: product.toJson());
    //   return Product.fromJson(response);
    // } catch (e) {
    //   rethrow;
    // }
  }

  // Para administradores
  Future<void> deleteProduct(int id) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Simular eliminación exitosa
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   await _apiService.delete('/products/$id');
    // } catch (e) {
    //   rethrow;
    // }
  }
}