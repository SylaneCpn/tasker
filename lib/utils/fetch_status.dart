sealed class FetchStatus<T, E> {
  bool get isNotFetchedYet => false;
  bool get isPending => false;
  bool get isFailed => false;
  bool get isSuccess=> false;

  const FetchStatus();

}

class NotFetchedYet<T,E> extends FetchStatus<T,E> {
  @override
  bool get isNotFetchedYet => true;

  const NotFetchedYet();

}

class Pending<T,E> extends FetchStatus<T,E> {
  @override
  bool get isPending => true;
}

class Failure<T,E> extends FetchStatus<T,E> {
  final E error;
  const Failure(this.error);

  @override
  bool get isFailed => true;
}

class Success<T,E> extends FetchStatus<T,E> {
  final T value;
  const Success(this.value);

  @override
  bool get isSuccess => true;
}