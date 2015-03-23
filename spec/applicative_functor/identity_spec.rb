require 'applicative_functor/identity'

i = ApplicativeFunctor::Identity.new ->(value) {
  value + 1
}
j = ApplicativeFunctor::Identity.new ->(value) {
  value * 2
}
k = ApplicativeFunctor::Identity.new 3
fail unless i.apply(j).apply(k).value == 8

# ApplicativeFunctor is also a functor
a = ApplicativeFunctor::Identity.new 4
fail unless a.fmap(->(value) {
  value / 2
}).value == 2
