import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../components/review/review_item.dart';

// Show all reviews of a product, customer can:
// - View all reviews
// - Navigate to review detail page to add their comment
class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({
    super.key,
    required this.productId,
  });

  static const String routeName = 'review';
  static const String path = '/home/product/review';

  final int productId;

  @override
  State<ProductReviewPage> createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem Đánh giá'),
      ),
      body: FutureBuilder(
        future: sl<ProductRepository>().getReviewProduct(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final resultEither = snapshot.data!;

            return resultEither.fold(
              (error) => MessageScreen.error(error.toString()),
              (ok) => ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                itemCount: ok.data!.reviews.length,
                itemBuilder: (context, index) {
                  final review = ok.data!.reviews[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReviewItem(review),
                  );
                },
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
    );
  }
}
