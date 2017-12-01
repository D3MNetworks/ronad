require 'danom/monad'

module Danom
  class Default < Monad
    def initialize(fallback, value)
      @fallback = Just.new(fallback).value
      super(value)
    end

    def value
      super || @fallback
    end

    def and_then &block
      if @value == nil
        Default.new @fallback, nil
      else
        Default.new @fallback, block.call(@value)
      end
    end
  end
end
