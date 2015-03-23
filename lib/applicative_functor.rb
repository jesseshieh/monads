require 'applicative_functor/identity'

module ApplicativeFunctor
  def fmap(proc)
    if @value.is_a? Proc
      self.class.new(->(value) {
        # compose them
        @value.call(proc.call(value))
      })
    else
      self.class.new(proc.call(@value))
    end
  end

  def apply(applicative_functor)
    applicative_functor.fmap(@value)
  end
end
