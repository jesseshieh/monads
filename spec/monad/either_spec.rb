require 'monad/either'

fail unless Monad::Either.lift(1).value == 1
fail unless Monad::Either.lift(-1).bind do |value|
  Monad::Either::Failure.new("Must be positive.")
end.value == "Must be positive."
fail unless Monad::Either.lift(1).bind do |value|
  Monad::Either::Success.new(value + 1)
end.value == 2
fail unless Monad::Either.lift(1).bind do |value|
  Monad::Either::Failure.new("Must be positive.")
end.bind do |value|
  Monad::Either::Success.new(value + 1)
end.value == "Must be positive."

# Either is also a Functor
fail unless Monad::Either.lift(1).fmap(->(value) {
  value * 5
}).value == 5
fail unless Monad::Either::Failure.new("oh no").fmap(->(value) {
  value * 5
}).value == "oh no"

# Either is also an ApplicativeFunctor
fail unless Monad::Either.lift(->(value) {
  value * 6
}).apply(Monad::Either.lift(8)).value == 48
fail unless Monad::Either::Failure.new("oh no").apply(Monad::Either.lift(8)).value == "oh no"
