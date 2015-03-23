module ApplicativeFunctor
  class Identity
    def initialize(value)
      @value = value
    end

    attr_reader :value

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
end
