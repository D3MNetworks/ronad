module Ronad
  # This class provides a common interface.
  #
  # @abstract
  class Monad
    (Object.new.methods - [:class]).each do |object_method|
      define_method object_method do |*args|
        and_then { |v| v.public_send(object_method, *args) }
      end
    end


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


    # "Fails" a maybe given a certain condition. If the condition is `false`
    # then Maybe(nil) will be returned. Useful for performing side-effects
    # given a certain condition
    #
    #   Maybe([]).and_then do |value|
    #     value.each(&:some_operation)
    #     OtherModule.finalize! # Side Effect should only happen if there
    #   end                     # are any values
    #
    # The following `and_then` only executes if `value` responds truthy to any?
    #
    #   Maybe([]).continue(&:any?).and_then do |value|
    #     value.each(&:some_operation)
    #     OtherModule.finalize!
    #   end
    # @return [Monad]
    def continue
      and_then do |value|
        value if yield value
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
