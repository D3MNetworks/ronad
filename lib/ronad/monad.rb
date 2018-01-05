module Ronad
  # This class provides a common interface.
  #
  # @abstract
  class Monad
    def initialize(value)
      if Monad === value
        @value = value.value
      else
        @value = value
      end
    end

    # Extract the value from the monad. If the underlying value responds to
    # #value then this will be bypassed instead.
    #
    # @see #monad_value
    # @return [Object] The unwrapped value
    def value
      if !(Monad === @value) && @value.respond_to?(:value)
        and_then{ |v| v.value }
      else
        monad_value
      end
    end


    # Extract the value from the monad. Can also be extracted via `~` unary
    # operator.
    #
    # @example
    #   ~Maybe("hello") #=> "HELLO"
    #   ~Maybe(nil)     #=> nil
    #
    # @note Useful when you want to extract the underlying value and it also
    #   responds to #value
    # @return [Object] The unwrapped value
    def monad_value
      if Monad === @value
        @value.value
      else
        @value
      end
    end

    # Alias for #monad_value
    #
    # @see #monad_value
    def ~@
      monad_value
    end


    # Proxy all Object methods to underlying value
    #
    # @private
    Object.new.methods.each do |object_method|
      define_method object_method do |*args|
        and_then { |v| v.public_send(object_method, *args) }
      end
    end

    private

    # Provides convinience for chaining methods together while maintaining a
    # monad.
    #
    # @example Chaining fetches on a hash that does not have the keys
    #   m = Maybe({})
    #   m_name = m[:person][:full_name] #=> Ronad::Maybe
    #   name = ~m_name #=> nil
    #
    # @example Safe navigation
    #   m = Maybe(nil)
    #   m_name = m.does.not.have.methods.upcase #=> Ronad::Maybe
    #   name = ~m_name #=> nil
    #
    # @return [Ronad::Monad]
    def method_missing(method, *args, &block)
      unwrapped_args = args.map do |arg|
        case arg
        when Monad then arg.value || arg
        else arg
        end
      end
      and_then { |value| value.public_send(method, *unwrapped_args, &block) }
    rescue TypeError
      self.class.new(nil)
    end

    def respond_to_missing?(method_name, include_private = false)
      if @value
        @value.respond_to?(method_name) || super
      else
        true
      end
    end
  end
end
