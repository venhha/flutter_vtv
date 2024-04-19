import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/login_with_username_and_password.dart';
import 'package:mockito/mockito.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../helpers/dummy_data/auth_test_data.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoginWithUsernameAndPasswordUC loginWithUsernameAndPasswordUC;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginWithUsernameAndPasswordUC = LoginWithUsernameAndPasswordUC(mockAuthRepository);
  });

  test('Should return [AuthEntity] when login is successful', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.loginWithUsernameAndPassword(
      tUsername,
      tPassword,
    )).thenAnswer(
      (_) async => Right(SuccessResponse(data: tAuthEntity)),
    );
    when(mockAuthRepository.cacheAuth(tAuthEntity)).thenAnswer(
      (_) async => const Right(null),
    );

    // Act

    final result = await loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(username: tUsername, password: tPassword),
    );

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.loginWithUsernameAndPassword(tUsername, tPassword));
    verify(mockAuthRepository.cacheAuth(tAuthEntity));
    // --expect something equals, isA, throwsA
    expect(result, Right(SuccessResponse(data: tAuthEntity)));
  });
  test('should return [Failure] when login is unsuccessful', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.loginWithUsernameAndPassword(
      any,
      any,
    )).thenAnswer(
      (_) async => const Left(ClientError()),
    );

    // Act
    final result = await loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(username: 'testUsername', password: 'testPassword'),
    );

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.loginWithUsernameAndPassword('testUsername', 'testPassword'));
    // --expect something equals, isA, throwsA
    expect(result, const Left(ClientError()));
  });
}
