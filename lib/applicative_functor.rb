require 'applicative_functor/identity'

module ApplicativeFunctor
  def fmap(proc)
    if @value.is_a? Proc
      Identity.new(->(value) {
        # compose them
        @value.call(proc.call(value))
      })
    else
      Identity.new(proc.call(@value))
    end
  end

  def apply(identity)
    identity.fmap(@value)
  end
end
