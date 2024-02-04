import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vtv/core/error/failures.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/check_token.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CheckTokenUC usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = CheckTokenUC(mockAuthRepository);
  });

  test('should return new token when get refresh token success', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.isValidToken(any)).thenAnswer((_) async => const Right(false));
    when(mockAuthRepository.getNewAccessToken()).thenAnswer((_) async => const Right('new_token'));
    // Act

    final result = await usecase('any');

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.isValidToken('any'));
    verify(mockAuthRepository.getNewAccessToken());
    // --expect something equals, isA, throwsA
    expect(result, const Right('new_token'));
  });
  test('should do nothing when get token is not expired', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.isValidToken(any)).thenAnswer((_) async => const Right(true));
    // Act

    final result = await usecase('any');

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.isValidToken('any'));
    verifyNever(mockAuthRepository.getNewAccessToken());
    // --expect something equals, isA, throwsA
    expect(result, const Right(null));
  });
  test('should return [Failure] when get token format is invalid', () async {
    // Arrange (setup @mocks)
    when(mockAuthRepository.isValidToken(any)).thenAnswer((_) async => const Left(UnexpectedFailure()));
    // Act

    final result = await usecase('any');

    // Assert
    // --verify something should(not) happen/call
    verify(mockAuthRepository.isValidToken('any'));
    verifyNever(mockAuthRepository.getNewAccessToken());
    // --expect something equals, isA, throwsA
    expect(result, const Left(UnexpectedFailure()));
  });
}
