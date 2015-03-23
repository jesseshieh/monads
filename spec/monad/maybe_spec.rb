require 'monad/maybe'

fail unless Monad::Maybe.lift(1).bind do |value|
  Monad::Maybe.lift(value + 1)
end.value == 2

fail unless Monad::Maybe.lift(nil).bind do |value|
  Monad::Maybe.lift(value + 1)
end.value == nil

fail unless Monad::Maybe.lift(1).value == 1

# Maybe is also a Functor
fail unless Monad::Maybe.lift(1).fmap(->(value) {
  value + 10
}).value == 11
fail unless Monad::Maybe.lift(nil).fmap(->(value) {
  value + 10
}).value == nil

# Maybe is also an ApplicativeFunctor
fail unless Monad::Maybe.lift(->(value) {
  value + 100
}).apply(Monad::Maybe.lift(5)).value == 105
fail unless Monad::Maybe.lift(nil).apply(Monad::Maybe.lift(5)).value == nil
