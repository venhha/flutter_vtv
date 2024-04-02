import 'package:flutter/material.dart';

import '../../../../core/presentation/components/custom_widgets.dart';
import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product_components/product_item.dart';
import 'product_detail_page.dart';

class FavoriteProductPage extends StatelessWidget {
  const FavoriteProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm yêu thích')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: sl<ProductRepository>().favoriteProductList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final resultEither = snapshot.data!;
              return resultEither.fold(
                (error) => MessageScreen.error(error.message),
                (ok) => GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: ok.data.map((f) {
                    return ProductItem(
                      productId: f.productId.toString(),
                      onPressed: () async {
                        final productResp = await sl<ProductRepository>().getProductDetailById(f.productId.toString());
                        productResp.fold(
                          (error) => MessageScreen.error(error.message),
                          (ok) {
                            final productDetail = ok.data;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductDetailPage(product: productDetail.product);
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return MessageScreen.error(snapshot.error.toString());
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
