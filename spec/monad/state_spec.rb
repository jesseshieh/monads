require 'monad/state'

def push(value)
  ->(stack) {
    stack.push(value)
    [nil, stack]
  }
end

pop = ->(stack) {
  value = stack.pop
  [value, stack]
}

fail unless Monad::State.lift(1).run([]) == [1, []]
fail unless Monad::State.new(push(4)).bind(&pop).bind(&pop).bind(&push(5)).
  run([1, 2, 3]) == [nil, [1, 2, 5]]

# State is also a Functor
fail unless Monad::State.lift(1).fmap(->(value) {
  value + 1
}).run([4]) == [2, [4]]

# State is also a ApplicativeFunctor
fail unless Monad::State.lift(->(value) {
  value + 1
}).apply(Monad::State.lift(1)).run([0]) == [2, [0]]
