import 'package:result/result.dart';

extension UnwrapOrThrow<T, E extends Exception> on Result<T , E> {
  T unwrapOrThrow() {
    switch(this) {
      case Ok( :final value):
        return value;
      case Err(:final error):
        throw error;
    }
  }
}