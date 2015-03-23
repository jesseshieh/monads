require 'monad/eventually'

# TODO: This is all messed up. This clearly isn't correct.
fail unless Monad::Eventually.lift(1).value == 1
fail unless Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new -> {
    value + 1
  }
end.value == 2
fail unless Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new -> {
    value + 1
  }
end.bind do |value|
  Monad::Eventually.new -> {
    value + 10
  }
end.value == 12

# Eventually is also a Functor
p Monad::Eventually.lift(1).fmap(->(value) {
  value + 4
}).value

# Eventually is also a ApplicativeFunctor
# I'm not sure about the order here. Normally, I'd say the function should go first?
fail unless Monad::Eventually.lift(4).apply(Monad::Eventually.lift(->(value) {
  value + 7
})).value == 11
