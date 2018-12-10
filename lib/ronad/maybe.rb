require 'ronad/monad'

module Ronad
  class Maybe < Monad
    # Creates a single Maybe from multiple values, shorting on the first
    # non-nil value.
    def self.from_multiple_values(*vals)
      new vals.detect { |v| Monad.new(v).value != nil }
    end

    # Allows for safe navigation on nil.
    #
    #   nil&.m1&.m2&.m3 #=> nil
    #
    #   ~Maybe(nil).m1.m2.m3 #=> nil
    #
    # Using a Maybe really shines when accessing a hash
    #
    #   ~Maybe({})[:person][:name].downcase.split(' ').join('-') #=> nil
    #
    #   {}.dig(:person, :name)&.downcase.&split(' ')&.join('-') #=> nil
    #
    # Using #and_then without the Monad#method_missing sugar is also useful if
    # you need to pass your value to another method
    #
    #   Maybe(nil).and_then{ |value| JSON.parse(value) } #=> Maybe
    #
    # The block only gets executed if value is not `nil`
    #
    # @return [Maybe]
    # @see Monad#method_missing
    def and_then
      if @value
        Maybe.new yield(@value)
      else
        Maybe.new(nil)
      end
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

    # "Fails" a maybe given a certain condition. If the condition is `true`
    # then Maybe(nil) will be returned.
    #
    # @see continue
    def halt
      and_then do |value|
        value unless yield value
      end
    end
  end
end
