import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';

import 'package:flutter_vtv/features/search/domain/response/page_product_response.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/base_response.dart';
import '../../domain/repository/search_product_repository.dart';
import '../data_sources/search_product_data_source.dart';

class SearchProductRepositoryImpl extends SearchProductRepository {
  SearchProductRepositoryImpl(this._searchProductDataSource);

  final SearchProductDataSource _searchProductDataSource;

  @override
  RespEitherData<PageProductResponse> searchAndPriceRangePageProductBySort(
      int page, int size, String keyword, String sort, int minPrice, int maxPrice) {
    try {
      final result = _searchProductDataSource.searchAndPriceRangePageProductBySort(page, size, keyword, sort, minPrice, maxPrice);
      return RespEitherData(
          Right(Future.value(result)) as FutureOr<Either<ErrorResponse, DataResponse<PageProductResponse>>> Function());
    } on ClientException catch (e) {
      return RespEitherData(Left(ClientError(code: e.code, message: e.message))
          as FutureOr<Either<ErrorResponse, DataResponse<PageProductResponse>>> Function());
    } on ServerException catch (e) {
      return RespEitherData(Left(ServerError(code: e.code, message: e.message))
          as FutureOr<Either<ErrorResponse, DataResponse<PageProductResponse>>> Function());
    } catch (e) {
      return RespEitherData(Left(UnexpectedError(message: e.toString()))
          as FutureOr<Either<ErrorResponse, DataResponse<PageProductResponse>>> Function());
    }
  }

  @override
  RespEitherData<PageProductResponse> searchPageProductBySort(int page, int size, String keyword, String sort) async {
    try {
      final result = await _searchProductDataSource.searchPageProductBySort(page, size, keyword, sort);
      return Right(result);
    } on ClientException catch (e) {
      return Left(ClientError(code: e.code, message: e.message));
    } on ServerException catch (e) {
      return Left(ServerError(code: e.code, message: e.message));
    } catch (e) {
      return Left(UnexpectedError(message: e.toString()));
    }
  }
}
