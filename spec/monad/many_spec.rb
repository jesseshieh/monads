require 'monad/many'

fail unless Monad::Many.new([1, 2, 3]).bind do |i|
  Monad::Many.new([i * 10, i * 100])
end.value == [10, 100, 20, 200, 30, 300]
fail unless Monad::Many.new([]).value == []

# Many is also a Functor
fail unless Monad::Many.new([1, 2, 3]).fmap(->(value) {
  value * value
}).value == [1, 4, 9]

# Many is also an ApplicativeFunctor
fail unless Monad::Many.new(->(value) {
  value * value * value
}).apply(Monad::Many.new([1, 2, 3])).value == [1, 8, 27]
