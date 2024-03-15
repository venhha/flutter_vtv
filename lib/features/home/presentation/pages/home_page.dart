import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/constants/enum.dart';
import 'package:flutter_vtv/features/home/presentation/components/search_components/btn_filter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product_repository.dart';
import '../components/product_components/best_selling_product_list.dart';
import '../components/product_components/category_list.dart';
import '../components/product_components/lazy_product_list_builder.dart';
import '../components/search_components/search_bar.dart';
import 'search_products_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  final _productPerPage = 4; // page size

  // search & filter & sort
  bool isFiltering = false;
  String currentSortType = 'newest'; // Default sort type
  int minPrice = 0;
  int maxPrice = 10000000; // 10tr

  bool isRefreshing = false;
  bool isShowing = true;
  bool filterPriceRange = false;
  int crossAxisCount = 2;

  Future<void> _refresh() async {
    setState(() {
      isRefreshing = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isRefreshing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: _buildHomePageAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh(); // Remove all widget and re-render due to call API
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            controller: scrollController,
            children: [
              // Category
              const CategoryList(),
              // Best selling
              BestSellingProductListBuilder(future: () => sl<ProductRepository>().getProductFilter(1, 10, SortTypes.bestSelling)),
              // Product
              _buildProductActionBar(context),
              isShowing
                  ? LazyProductListBuilder(
                      crossAxisCount: crossAxisCount,
                      scrollController: scrollController,
                      dataCallback: (page) async {
                        if (isFiltering) {
                          if (filterPriceRange) {
                            return sl<ProductRepository>().getProductFilterByPriceRange(
                              page,
                              _productPerPage,
                              minPrice,
                              maxPrice,
                              currentSortType,
                            );
                          } else {
                            return sl<ProductRepository>().getProductFilter(page, _productPerPage, currentSortType);
                          }
                        }
                        return sl<ProductRepository>().getSuggestionProductsRandomly(page, _productPerPage);
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildProductActionBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Danh sách sản phẩm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        BtnFilter(
          context,
          isFiltering: isFiltering,
          minPrice: minPrice,
          maxPrice: maxPrice,
          sortType: currentSortType,
          onFilterChanged: (filterParams) {
            if (filterParams != null) {
              setState(() {
                isShowing = false;
                isFiltering = filterParams.isFiltering;
                minPrice = filterParams.minPrice;
                maxPrice = filterParams.maxPrice;
                currentSortType = filterParams.sortType;
                filterPriceRange = filterParams.filterPriceRange;
              });
            }
            // use [isSortTypeChanged] to completed remove [LazyProductListBuilder]
            // out of the widget tree before re-render
            Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                isShowing = true;
              });
            });
          },
        ),
      ],
    );
  }

  // Widget _buildBestSelling() {
  //   return BestSellingProductList(
  //     future: () => sl<ProductRepository>().getProductFilter(1, 10),
  //   );
  //   // return SizedBox(
  //   //   height: 200,
  //   //   child: FutureBuilder<RespData<ProductDTO>>(
  //   //     future: sl<ProductRepository>().getProductFilter(1, 10),
  //   //     builder: (context, snapshot) {
  //   //       if (snapshot.connectionState != ConnectionState.done) {
  //   //         return const Center(
  //   //           child: CircularProgressIndicator(),
  //   //         );
  //   //       }
  //   //       if (snapshot.hasError) {
  //   //         return Center(
  //   //           child: Text('Error: ${snapshot.error}'),
  //   //         );
  //   //       }
  //   //       return snapshot.data!.fold(
  //   //         (errorResp) => Center(
  //   //           child: Text('Error: $errorResp', style: const TextStyle(color: Colors.red)),
  //   //         ),
  //   //         (dataResp) {
  //   //           return BestSelling(
  //   //             bestSellingProductImages: dataResp.data.products.map((e) => e.image).toList(),
  //   //             bestSellingProductNames: dataResp.data.products.map((e) => e.name).toList(),
  //   //           );
  //   //         },
  //   //       );
  //   //     },
  //   //   ),
  //   // );
  // }

  AppBar _buildHomePageAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "VTV",
        style: GoogleFonts.ribeye(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: SearchBarComponent(
            clearOnSubmit: true,
            onSubmitted: (text) => context.go(SearchProductsPage.route, extra: text),
          ),
        ),
      ],
    );
  }
}
