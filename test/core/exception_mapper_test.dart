import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import 'package:glow_up/core/errors/exceptions/auth_exception.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import 'package:glow_up/core/errors/exceptions/network_exception.dart';
import 'package:glow_up/core/errors/exceptions/storage_exception.dart';
import 'package:glow_up/core/network/connectivity_service.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

void main() {
  setUp(() => ConnectivityService.debugSetOnline(true));

  group('network errors are never reported as auth errors', () {
    test('AuthRetryableFetchException maps to a network message', () {
      // هاد يلي بترميه supabase لما ما يقدر يوصل للخادم — وبما إنه
      // بيرث من AuthException كان بينمسك كـ "خطأ تسجيل دخول".
      final message = ExceptionMapper.mapToMessage(
        supabase.AuthRetryableFetchException(message: 'Connection refused'),
      );
      expect(message, isNot(ErrorMessages.authGeneric));
      expect(message, ErrorMessages.serverUnreachable);
    });

    test('offline device gets the no-internet message', () {
      ConnectivityService.debugSetOnline(false);
      expect(
        ExceptionMapper.mapToMessage(
          supabase.AuthRetryableFetchException(message: 'Connection refused'),
        ),
        ErrorMessages.noInternet,
      );
    });

    test('DNS failure reads as no internet even when online is optimistic', () {
      expect(
        ExceptionMapper.mapToMessage(
          const SocketException("Failed host lookup: 'db.supabase.co'"),
        ),
        ErrorMessages.noInternet,
      );
    });

    test('http.ClientException from postgrest maps to network', () {
      final result = ExceptionMapper.mapToException(
        http.ClientException('Connection closed before full header'),
      );
      expect(result, isA<NetworkException>());
    });

    test('TimeoutException maps to the timeout message', () {
      expect(
        ExceptionMapper.mapToMessage(TimeoutException('slow')),
        ErrorMessages.requestTimeout,
      );
    });
  });

  group('auth errors map from the structured code', () {
    void expectCode(String code, String expected) {
      expect(
        ExceptionMapper.mapToMessage(
          supabase.AuthApiException(
            'any wording',
            code: code,
            statusCode: '400',
          ),
        ),
        expected,
        reason: 'code "$code" should not fall through to the generic message',
      );
    }

    test('invalid_credentials', () {
      expectCode('invalid_credentials', ErrorMessages.invalidCredentials);
    });

    test('email_not_confirmed', () {
      expectCode('email_not_confirmed', ErrorMessages.emailNotConfirmed);
    });

    test('email_exists', () {
      expectCode('email_exists', ErrorMessages.emailAlreadyInUse);
    });

    test('weak_password', () {
      expectCode('weak_password', ErrorMessages.weakPassword);
    });

    test('same_password', () {
      expectCode('same_password', ErrorMessages.samePassword);
    });

    test('otp_expired reads as an expired recovery link', () {
      expectCode('otp_expired', ErrorMessages.resetLinkExpired);
    });

    test('session codes map to session expired', () {
      expectCode('session_expired', ErrorMessages.sessionExpired);
      expectCode('refresh_token_not_found', ErrorMessages.sessionExpired);
      expectCode('bad_jwt', ErrorMessages.sessionExpired);
    });

    test('user_banned', () {
      expectCode('user_banned', ErrorMessages.accountDisabled);
    });

    test('over_request_rate_limit', () {
      expectCode('over_request_rate_limit', ErrorMessages.tooManyAttempts);
    });

    test('signup_disabled', () {
      expectCode('signup_disabled', ErrorMessages.signUpDisabled);
    });
  });

  group('auth falls back to the message when no code is present', () {
    test('legacy "Invalid login credentials" still works', () {
      expect(
        ExceptionMapper.mapToMessage(
          const supabase.AuthException('Invalid login credentials'),
        ),
        ErrorMessages.invalidCredentials,
      );
    });

    test('401 without a code reads as bad credentials, not generic', () {
      expect(
        ExceptionMapper.mapToMessage(
          const supabase.AuthException('nope', statusCode: '401'),
        ),
        ErrorMessages.invalidCredentials,
      );
    });

    test('a genuinely unknown auth error still returns something usable', () {
      final result = ExceptionMapper.mapToException(
        const supabase.AuthException('something new', statusCode: '400'),
      );
      expect(result, isA<AppAuthException>());
      expect(result.message, ErrorMessages.authGeneric);
    });
  });

  group('database errors', () {
    String map(String code) => ExceptionMapper.mapToMessage(
      supabase.PostgrestException(message: 'db', code: code),
    );

    test('unique violation', () {
      expect(map('23505'), ErrorMessages.duplicateEntry);
    });

    test('not-null violation names the real problem', () {
      expect(map('23502'), ErrorMessages.missingRequiredData);
    });

    test('invalid text representation', () {
      expect(map('22P02'), ErrorMessages.invalidData);
    });

    test('RLS denial', () {
      expect(map('42501'), ErrorMessages.permissionDenied);
      expect(map('403'), ErrorMessages.permissionDenied);
    });

    test('no rows found', () {
      expect(map('PGRST116'), ErrorMessages.recordNotFound);
    });

    test('expired JWT reads as an expired session', () {
      expect(map('PGRST301'), ErrorMessages.sessionExpired);
      expect(
        ExceptionMapper.mapToMessage(
          const supabase.PostgrestException(message: 'JWT expired'),
        ),
        ErrorMessages.sessionExpired,
      );
    });

    test('serialization failure asks the user to retry', () {
      expect(map('40001'), ErrorMessages.serverBusy);
    });
  });

  group('storage errors', () {
    String map(String status, [String message = 'storage']) =>
        ExceptionMapper.mapToMessage(
          supabase.StorageException(message, statusCode: status),
        );

    test(
      'payload too large',
      () => expect(map('413'), ErrorMessages.fileTooLarge),
    );
    test('not found', () => expect(map('404'), ErrorMessages.fileNotFound));
    test('conflict', () => expect(map('409'), ErrorMessages.fileAlreadyExists));
    test('unsupported type', () {
      expect(map('415'), ErrorMessages.unsupportedFileType);
    });
    test('forbidden', () => expect(map('403'), ErrorMessages.permissionDenied));

    test('size message without a status code still maps', () {
      expect(
        ExceptionMapper.mapToMessage(
          const supabase.StorageException(
            'The object exceeded the maximum allowed size',
          ),
        ),
        ErrorMessages.fileTooLarge,
      );
    });
  });

  group('other error shapes', () {
    test('our own AppException passes straight through', () {
      final original = DatabaseException.permissionDenied();
      expect(
        identical(ExceptionMapper.mapToException(original), original),
        isTrue,
      );
    });

    test('a bad row cast reads as a data problem, not "unexpected"', () {
      expect(
        ExceptionMapper.mapToMessage(
          const FormatException('Invalid date format'),
        ),
        ErrorMessages.invalidData,
      );
    });

    test('a truly unknown object falls back to unexpected', () {
      expect(ExceptionMapper.mapToMessage(Object()), ErrorMessages.unexpected);
    });

    test('mapToException returns typed exceptions for behaviour branching', () {
      expect(
        ExceptionMapper.mapToException(TimeoutException('x')),
        isA<NetworkException>(),
      );
      expect(
        ExceptionMapper.mapToException(
          const supabase.StorageException('x', statusCode: '413'),
        ),
        isA<AppStorageException>(),
      );
    });
  });
}
