require 'danom/monad'

module Danom
  class Just < Monad
    class CannotBeNil < StandardError; end

    def initialize(value)
      raise CannotBeNil if value == nil
      super
    end

    def and_then(&block)
      Just.new block.call(@value)
    end

    def method_missing(method, *args, &block)
      and_then { |value| value.public_send(method, *args, &block) }
    end

    def respond_to_missing?(method_name, include_private = false)
      raise CannotBeNil unless @value
      @value.public_send(method_name, include_private = false)
    end

  end
end
