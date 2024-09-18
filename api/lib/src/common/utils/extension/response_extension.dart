import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

extension ResponseX on Response {
  Response notFound() => Response(
        statusCode: HttpStatus.notFound,
        body: 'Resource not found',
      );
  Response badRequest() => Response(
        statusCode: HttpStatus.badRequest,
        body: 'Bad request',
      );
  Response methodNotAllowed() => Response(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'Method not allowed',
      );
  Response noContent() => Response(
        statusCode: HttpStatus.noContent,
        body: 'No content',
      );

  Response unauthorized() => Response(
        statusCode: HttpStatus.unauthorized,
        body: 'Unauthorized',
      );
}
