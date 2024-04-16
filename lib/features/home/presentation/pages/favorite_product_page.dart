import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product_components/product_item.dart';
import 'product_detail_page.dart';

class FavoriteProductPage extends StatelessWidget {
  const FavoriteProductPage({super.key});

  static const String routeName = 'favorite-product';
  static const String path = '/user/favorite-product';

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
                      productId: f.productId,
                      onPressed: () async {
                        final productResp = await sl<ProductRepository>().getProductDetailById(f.productId);
                        productResp.fold(
                          (error) => MessageScreen.error(error.message),
                          (ok) {
                            final productDetail = ok.data;
                            context.go(ProductDetailPage.path, extra: productDetail);
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return ProductDetailPage(productDetail: productDetail);
                            //     },
                            //   ),
                            // );
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
