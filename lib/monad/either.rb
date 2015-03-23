require 'applicative_functor'

module Monad
  class Either
    class Success
      include ApplicativeFunctor

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def success?
        true
      end

      def bind(&block)
        block.call(@value)
      end
    end

    class Failure
      include ApplicativeFunctor

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def success?
        false
      end

      def fmap(proc)
        self
      end

      def apply(either)
        self
      end

      def bind(&block)
        self
      end
    end

    def self.lift(value)
      Success.new(value)
    end
  end
end
