module Ronad
  # Chain operations on lists that can possibly return other lists.
  #
  #     sentence = 'hello-there my-friend@good-bye my-pal'
  #
  #     words = sentence.split('@').flat_map do |partials|
  #       partials.split('-').map do |word|
  #          word + '!'
  #       end
  #     end
  #
  # Or using Many:
  #
  #     word = Many(sentence).split('@').split('-') + '!'
  #     words = word.value
  #
  # A Many can be useful for tranversing 'has many' relationships in a
  # database. For example given the following relations with each relationship
  # having 0 or more:
  #
  # - store has many products
  # - product has many variants
  # - variant has many inventory_units
  #
  # To obtain all the inventory_units of a store:
  #
  #     store.products.flat_map(&:variants).flat_map(&:inventory_units)
  #
  # Or if a certain parameterized scope had to be used:
  #
  #     store.products.flat_map do |product|
  #       prodcut.variants.where(some_state: true).flat_map do |variant|
  #         variant.inventory_units.where(physical: true)
  #       end
  #     end
  #
  # With Many:
  #
  #     Many(store).products.variants.where(some_state: true).inventory_units.where(physical: true)
  #       .value
  #
  # A Many will also remove nil values:
  #
  #     Many([1,2,nil,4,nil]).value #=> [1,2,4]
  class Many < Monad
    # Wraps a value in the Many monad.
    #
    # @param value - Does not need to be an enumerable as
    #   it will be wrapped in an Array.
    # @param return_lazy - specifies if #monad_value should return a lazy
    #   enumerator. If left as nil, then #monad_value will return a lazy
    #   enumerator if one was initially provided to the constructor.
    def initialize(value, return_lazy: nil)
      @return_lazy = if return_lazy.nil?
        value.is_a? Enumerator::Lazy
      else
        return_lazy
      end

      if value.is_a? Enumerable
        @value = value.lazy
      else
        @value = Array(value).lazy
      end
    end


    def and_then &b
      from_value @value.reject(&:nil?).flat_map(&b)
    end

    # Returns the underlying value of the many. Always an Enumerator, sometimes
    # lazy.
    # @see #initialize
    def monad_value
      if @return_lazy
        super
      else
        super.to_a
      end
    end

    protected

    def from_value(value)
      self.class.new(value, return_lazy: @return_lazy)
    end
  end
end
