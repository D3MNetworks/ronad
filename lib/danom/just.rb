require 'danom/monad'

module Danom
  # Useful for immediately failing when a nil pops up.
  #   name = get_name(person) #=> nil
  #   # ... later somewhere
  #   name.upcase # Error!
  #
  # Using a Just catches the problem at the source
  #
  #   name = Just(get_name(person)) # Error!
  class Just < Monad
    # Raised if the underlying value of Just becomes nil
    class CannotBeNil < StandardError; end

    # @raise [Danom::Just::CannotBeNil] if value is provided as nil
    def initialize(value)
      raise CannotBeNil if value == nil
      super
    end

    # Similar to Maybe#and_then but raises an error if the value ever becomes
    # nil.
    #
    # @example
    #   j = Just('hello') #=> Just
    #   text = ~j #=> 'hello'
    #
    # @example Failing when becomes nil
    #   j = Just({}) #=> Just
    #   j[:name] #=> Danom::Monad::CannotBeNil
    #
    #
    # @see Maybe#and_then
    # @see Monad#method_missing
    # @return [Just]
    def and_then(&block)
      Just.new block.call(@value)
    end
  end
end
