require 'functor/identity'

add1 = ->(value) {
  value + 1
}

fail unless Functor::Identity.new(5).fmap(&add1).value == 6
