require 'monad/eventually'

# TODO: This is all messed up. This clearly isn't correct.
fail unless Monad::Eventually.lift(1).run == 1
fail unless Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new -> {
    value + 1
  }
end.run == 2
fail unless Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new -> {
    value + 1
  }
end.bind do |value|
  Monad::Eventually.new -> {
    value + 10
  }
end.run == 12

# Eventually is also a Functor
fail unless Monad::Eventually.lift(1).fmap(->(value) {
  value + 4
}).run == 5

# Eventually is also a ApplicativeFunctor
# I'm not sure about the order here. Normally, I'd say the function should go first?
fail unless Monad::Eventually.lift(->(value) {
  value + 1
}).apply(Monad::Eventually.lift(1)).run == 2
