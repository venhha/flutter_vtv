import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

abstract class VoucherRepository {
  FRespData<List<VoucherEntity>> listAll();
  FRespData<List<VoucherEntity>> listOnSystem();
  FRespData<List<VoucherEntity>> listOnShop(String shopId);
}
