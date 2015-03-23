require 'monad/log'

fail unless Monad::Log.lift(0).value == 0
fail unless Monad::Log.lift(0).log == []
l =Monad:: Log.lift(9).bind do |value|
  [value + 1, "Add 1. "]
end.bind do |value|
  [value * 10, "Times 10. "]
end
fail unless l.value == 100
fail unless l.log.join == "Add 1. Times 10. "

# Log is also a Functor
fail unless Monad::Log.lift(1).fmap(->(value) {
  value + 1
}).value == 2

# Log is also a ApplicativeFunctor
fail unless Monad::Log.lift(->(value) {
  value + 1
}).apply(Monad::Log.lift(1)).value == 2
