import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/core/repositories/product_repository.dart';
import 'package:music_app/core/widgets/loading_indicator.dart';
import 'package:music_app/features/products/bloc/product_bloc.dart';
import 'package:music_app/features/products/bloc/product_event.dart';
import 'package:music_app/features/products/bloc/product_state.dart';
import 'package:music_app/features/products/widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: BlocProvider(
        create: (context) => ProductBloc(
          productRepository: RepositoryProvider.of<ProductRepository>(context),
        )..add(FetchProducts()),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const LoadingIndicator();
            }
            if (state is ProductLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75, // Ajusta según el diseño de tu tarjeta
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    name: product.nombre,
                    price: '\$${product.precio.toStringAsFixed(2)}',
                    imageUrl: product.urlImagen,
                  );
                },
              );
            }
            if (state is ProductError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            return const Center(
              child: Text('Inicia la búsqueda de productos.'),
            );
          },
        ),
      ),
    );
  }
}
