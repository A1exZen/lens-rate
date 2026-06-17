/// Exhaustive failure types for rate operations (docs §23.5).
///
/// Sealed so call sites can `switch` and the compiler flags missing cases.
sealed class RatesFailure implements Exception {
  const RatesFailure();
}

/// Network was unreachable or the request failed.
class NetworkFailure extends RatesFailure {
  const NetworkFailure(this.message);
  final String message;
}

/// The rate provider responded but with an unexpected / error payload.
class RateProviderFailure extends RatesFailure {
  const RateProviderFailure(this.message);
  final String message;
}

/// No cached rates available while offline (docs §6.4).
class NoCachedRatesFailure extends RatesFailure {
  const NoCachedRatesFailure();
}
