module Monad
  class Log
    def initialize(value, log)
      @value = value
      @log = log
    end

    attr_reader :value
    attr_reader :log

    def bind(&block)
      new_value, new_log = block.call(@value)
      Log.new(new_value, @log + [new_log])
    end
  end
end
