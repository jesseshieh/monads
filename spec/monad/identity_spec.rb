require 'monad/identity'

fail unless Monad::Identity.new(3).bind do |value|
  Monad::Identity.new(value * 2)
end.value == 6
