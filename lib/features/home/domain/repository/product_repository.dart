import '../../../../core/constants/typedef.dart';
import '../dto/product_dto.dart';

abstract class ProductRepository {
  FRespData<ProductDTO> getSuggestionProductsRandomly(int page, int size);

  FRespData<ProductDTO> getProductFilterByPriceRange(
    int page,
    int size,
    int minPrice,
    int maxPrice,
    String filter,
  );
}
