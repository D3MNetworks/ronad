require 'ronad/monad'

module Ronad
  # A default "monad". Not technically a monad as it take two values.
  class Default < Monad
    # @param fallback [Object] The value on which to fallback if the doesn't
    #   satisfy Just(value)
    # @param value [Object]
    def initialize(fallback, value)
      @fallback = Just.new(fallback).value
      super(value)
    end

    # @override
    def monad_value
      super || @fallback
    end

    # Allows chaining on nil values with a fallback
    #
    # @note The fallback does not get the transformations
    #
    # @example
    #   d = Default('Missing name', nil)
    #   d = d.upcase.split.join #=> Ronad::Default
    #   name = ~d # 'Missing name'
    #
    #   d = Default('Missing name', 'Uri')
    #   d = d.upcase #=> Ronad::Default
    #   name = ~d # 'URI'
    #
    # Default can be combined with a maybe. Extracting the value is recursive
    # and will never return another monad.
    #
    # @example Combining with a Maybe
    #   m = Maybe(nil)
    #   d = Default('No name', m) #=> Ronad::Default
    #   name = ~d #=>  'No name'
    #
    # @see Ronad::Monad#method_missing
    def and_then &block
      if @value == nil
        Default.new @fallback, nil
      else
        Default.new @fallback, block.call(@value)
      end
    end
  end
end
