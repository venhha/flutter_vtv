import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/order_repository.dart';
import '../components/voucher_item.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({
    super.key,
    this.returnValue = false,
    this.future,
  });

  static const String routeName = 'voucher';
  static const String path = '/user/voucher';

  final bool returnValue;
  final FRespData<List<VoucherEntity>>? future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: FutureBuilder(
          future: future != null ? future! : sl<OrderRepository>().voucherListAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final respEither = snapshot.data!;
              return respEither.fold(
                (error) {
                  return MessageScreen.error(error.message);
                },
                (ok) {
                  if (ok.data!.isEmpty) {
                    return MessageScreen(
                      message: 'Không tìm thấy voucher nào!',
                      text: 'Quay lại',
                      onPressed: () => Navigator.of(context).pop(),
                    );
                  }

                  return ListView.builder(
                    itemCount: ok.data!.length,
                    itemBuilder: (context, index) {
                      return VoucherItem(
                        voucher: ok.data![index],
                        onSelected: (voucher) {
                          if (returnValue) Navigator.of(context).pop(voucher);
                        },
                      );
                    },
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
