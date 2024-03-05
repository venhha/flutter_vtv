import '../../../../core/constants/typedef.dart';
import '../dto/product_dto.dart';

abstract class ProductRepository {
  RespEitherData<ProductDTO> getSuggestionProductsRandomly(int page, int size);
}
