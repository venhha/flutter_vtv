import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/features/profile/domain/repository/profile_repository.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

import '../data_sources/profile_data_source.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(this._profileDataSource);
  final ProfileDataSource _profileDataSource;

  @override
  FRespData<AddressEntity> addAddress(AddOrUpdateAddressParam addOrUpdateAddressParam) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.addAddress(addOrUpdateAddressParam),
    );
  }

  @override
  FRespData<List<AddressEntity>> getAllAddress() async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getAllAddress(),
    );
  }

  @override
  FRespEither updateAddressStatus(int addressId) async {
    return await handleSuccessResponseFromDataSource(
      noDataCallback: () async => await _profileDataSource.updateAddressStatus(addressId),
    );
  }

  @override
  FRespData<AddressEntity> updateAddress(AddOrUpdateAddressParam addOrUpdateAddressParam) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.updateAddress(addOrUpdateAddressParam),
    );
  }

  @override
  FRespData<LoyaltyPointEntity> getLoyaltyPoint() async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getLoyaltyPoint(),
    );
  }

  @override
  FRespData<List<LoyaltyPointHistoryEntity>> getLoyaltyPointHistory(int loyaltyPointId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _profileDataSource.getLoyaltyPointHistory(loyaltyPointId),
    );
  }

  @override
  FRespData<bool> hasAddress() async {
    final response = await _profileDataSource.getAllAddress();

    if (response.data?.isNotEmpty == true) {
      return const Right(SuccessResponse(data: true));
    } else if (response.data?.isEmpty == true) {
      return const Right(SuccessResponse(data: false));
    } else {
      return Left(UnexpectedError(message: response.message));
    }
  }
}
