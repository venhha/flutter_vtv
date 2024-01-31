// Mocks generated by Mockito 5.4.4 from annotations
// in flutter_vtv/test/helpers/test_helper.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:convert' as _i14;
import 'dart:typed_data' as _i16;

import 'package:connectivity_plus/connectivity_plus.dart' as _i12;
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart'
    as _i13;
import 'package:dartz/dartz.dart' as _i2;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i4;
import 'package:flutter_vtv/core/error/failures.dart' as _i9;
import 'package:flutter_vtv/core/helpers/secure_storage_helper.dart' as _i11;
import 'package:flutter_vtv/features/auth/data/data_sources/auth_data_source.dart'
    as _i10;
import 'package:flutter_vtv/features/auth/data/models/auth_model.dart' as _i3;
import 'package:flutter_vtv/features/auth/domain/entities/auth_entity.dart'
    as _i5;
import 'package:flutter_vtv/features/auth/domain/repositories/auth_repository.dart'
    as _i7;
import 'package:http/http.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i15;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAuthModel_1 extends _i1.SmartFake implements _i3.AuthModel {
  _FakeAuthModel_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFlutterSecureStorage_2 extends _i1.SmartFake
    implements _i4.FlutterSecureStorage {
  _FakeFlutterSecureStorage_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAuthEntity_3 extends _i1.SmartFake implements _i5.AuthEntity {
  _FakeAuthEntity_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResponse_4 extends _i1.SmartFake implements _i6.Response {
  _FakeResponse_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamedResponse_5 extends _i1.SmartFake
    implements _i6.StreamedResponse {
  _FakeStreamedResponse_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i7.AuthRepository {
  MockAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.Either<_i9.Failure, _i5.AuthEntity>> retrieveAuth() =>
      (super.noSuchMethod(
        Invocation.method(
          #retrieveAuth,
          [],
        ),
        returnValue: _i8.Future<_i2.Either<_i9.Failure, _i5.AuthEntity>>.value(
            _FakeEither_0<_i9.Failure, _i5.AuthEntity>(
          this,
          Invocation.method(
            #retrieveAuth,
            [],
          ),
        )),
      ) as _i8.Future<_i2.Either<_i9.Failure, _i5.AuthEntity>>);

  @override
  _i8.Future<_i2.Either<_i9.Failure, _i5.AuthEntity>>
      loginWithUsernameAndPassword(
    String? username,
    String? password,
  ) =>
          (super.noSuchMethod(
            Invocation.method(
              #loginWithUsernameAndPassword,
              [
                username,
                password,
              ],
            ),
            returnValue:
                _i8.Future<_i2.Either<_i9.Failure, _i5.AuthEntity>>.value(
                    _FakeEither_0<_i9.Failure, _i5.AuthEntity>(
              this,
              Invocation.method(
                #loginWithUsernameAndPassword,
                [
                  username,
                  password,
                ],
              ),
            )),
          ) as _i8.Future<_i2.Either<_i9.Failure, _i5.AuthEntity>>);

  @override
  _i8.Future<_i2.Either<_i9.Failure, void>> cacheAuth(
          _i5.AuthEntity? authEntity) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheAuth,
          [authEntity],
        ),
        returnValue: _i8.Future<_i2.Either<_i9.Failure, void>>.value(
            _FakeEither_0<_i9.Failure, void>(
          this,
          Invocation.method(
            #cacheAuth,
            [authEntity],
          ),
        )),
      ) as _i8.Future<_i2.Either<_i9.Failure, void>>);
}

/// A class which mocks [AuthDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthDataSource extends _i1.Mock implements _i10.AuthDataSource {
  MockAuthDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i3.AuthModel> loginWithUsernameAndPassword(
    String? username,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #loginWithUsernameAndPassword,
          [
            username,
            password,
          ],
        ),
        returnValue: _i8.Future<_i3.AuthModel>.value(_FakeAuthModel_1(
          this,
          Invocation.method(
            #loginWithUsernameAndPassword,
            [
              username,
              password,
            ],
          ),
        )),
      ) as _i8.Future<_i3.AuthModel>);

  @override
  _i8.Future<void> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [SecureStorageHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockSecureStorageHelper extends _i1.Mock
    implements _i11.SecureStorageHelper {
  MockSecureStorageHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FlutterSecureStorage get I => (super.noSuchMethod(
        Invocation.getter(#I),
        returnValue: _FakeFlutterSecureStorage_2(
          this,
          Invocation.getter(#I),
        ),
      ) as _i4.FlutterSecureStorage);

  @override
  _i8.Future<bool> get isLogin => (super.noSuchMethod(
        Invocation.getter(#isLogin),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<_i5.AuthEntity> readAuth() => (super.noSuchMethod(
        Invocation.method(
          #readAuth,
          [],
        ),
        returnValue: _i8.Future<_i5.AuthEntity>.value(_FakeAuthEntity_3(
          this,
          Invocation.method(
            #readAuth,
            [],
          ),
        )),
      ) as _i8.Future<_i5.AuthEntity>);

  @override
  _i8.Future<void> cacheAuth(String? jsonData) => (super.noSuchMethod(
        Invocation.method(
          #cacheAuth,
          [jsonData],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> deleteAll() => (super.noSuchMethod(
        Invocation.method(
          #deleteAll,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [Connectivity].
///
/// See the documentation for Mockito's code generation for more information.
class MockConnectivity extends _i1.Mock implements _i12.Connectivity {
  MockConnectivity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Stream<_i13.ConnectivityResult> get onConnectivityChanged =>
      (super.noSuchMethod(
        Invocation.getter(#onConnectivityChanged),
        returnValue: _i8.Stream<_i13.ConnectivityResult>.empty(),
      ) as _i8.Stream<_i13.ConnectivityResult>);

  @override
  _i8.Future<_i13.ConnectivityResult> checkConnectivity() =>
      (super.noSuchMethod(
        Invocation.method(
          #checkConnectivity,
          [],
        ),
        returnValue: _i8.Future<_i13.ConnectivityResult>.value(
            _i13.ConnectivityResult.bluetooth),
      ) as _i8.Future<_i13.ConnectivityResult>);
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClient extends _i1.Mock implements _i6.Client {
  MockHttpClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i6.Response> head(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #head,
          [url],
          {#headers: headers},
        ),
        returnValue: _i8.Future<_i6.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #head,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i8.Future<_i6.Response>);

  @override
  _i8.Future<_i6.Response> get(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
          {#headers: headers},
        ),
        returnValue: _i8.Future<_i6.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #get,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i8.Future<_i6.Response>);

  @override
  _i8.Future<_i6.Response> post(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i14.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i8.Future<_i6.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #post,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i8.Future<_i6.Response>);

  @override
  _i8.Future<_i6.Response> put(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i14.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i8.Future<_i6.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #put,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i8.Future<_i6.Response>);

  @override
  _i8.Future<_i6.Response> patch(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i14.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i8.Future<_i6.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #patch,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i8.Future<_i6.Response>);

  @override
  _i8.Future<_i6.Response> delete(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i14.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i8.Future<_i6.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #delete,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i8.Future<_i6.Response>);

  @override
  _i8.Future<String> read(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [url],
          {#headers: headers},
        ),
        returnValue: _i8.Future<String>.value(_i15.dummyValue<String>(
          this,
          Invocation.method(
            #read,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i8.Future<String>);

  @override
  _i8.Future<_i16.Uint8List> readBytes(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readBytes,
          [url],
          {#headers: headers},
        ),
        returnValue: _i8.Future<_i16.Uint8List>.value(_i16.Uint8List(0)),
      ) as _i8.Future<_i16.Uint8List>);

  @override
  _i8.Future<_i6.StreamedResponse> send(_i6.BaseRequest? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [request],
        ),
        returnValue:
            _i8.Future<_i6.StreamedResponse>.value(_FakeStreamedResponse_5(
          this,
          Invocation.method(
            #send,
            [request],
          ),
        )),
      ) as _i8.Future<_i6.StreamedResponse>);

  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
