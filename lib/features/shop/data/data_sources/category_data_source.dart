import 'dart:convert';

import 'package:flutter_vtv/core/network/base_response.dart';
import 'package:flutter_vtv/features/shop/data/models/category_model.dart';
import 'package:http/http.dart' as http show Client;

import '../../../../core/constants/api.dart';
import '../../../../core/network/response_handler.dart';

abstract class CategoryDataSource {
  Future<DataResponse<List<CategoryModel>>> getAllParentCategories();
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final http.Client _client;

  CategoryDataSourceImpl(this._client);

  @override
  Future<DataResponse<List<CategoryModel>>> getAllParentCategories() async {
    // send request
    final response = await _client.get(
      baseUri(path: kAPIGetAllCategoryURL),
      headers: baseHttpHeaders(),
    );

    // decode response using utf8
    final utf8BodyMap = utf8.decode(response.bodyBytes);
    final decodedBody = jsonDecode(utf8BodyMap);

    // handle response
    if (response.statusCode == 200) {
      final result = CategoryModel.fromJsonList(utf8BodyMap);
      return DataResponse<List<CategoryModel>>(
        result,
        code: response.statusCode,
        message: decodedBody['message'],
      );
    } else {
      throwException(
        code: response.statusCode,
        message: jsonDecode(utf8BodyMap)['message'],
        url: kAPIAuthLoginURL,
      );
    }
  }
}
