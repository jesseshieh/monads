require 'monad/eventually'

fail unless Monad::Eventually.lift(1).run == 1
fail unless Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new -> {
    value + 1
  }
end.run == 2
eventually = Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new -> {
    sleep 1
    value + 1
  }
end.bind do |value|
  Monad::Eventually.new -> {
    sleep 1
    value + 10
  }
end
fail unless eventually.run == 12

# Eventually is also a Functor
fail unless Monad::Eventually.lift(1).fmap(->(value) {
  value + 4
}).run == 5
fail unless Monad::Eventually.lift(1).fmap(->(value) {
  value + 4
}).fmap(->(value) {
  value + 4
}).run == 9

# Eventually is also a ApplicativeFunctor
# I'm not sure about the order here. Normally, I'd say the function should go first?
fail unless Monad::Eventually.lift(->(value) {
  value + 1
}).apply(Monad::Eventually.lift(1)).run == 2

add1 = ->(value) { value + 1 }
fail unless Monad::Eventually.lift(add1).
  apply(Monad::Eventually.lift(add1)).
  apply(Monad::Eventually.lift(1)).run == 3
