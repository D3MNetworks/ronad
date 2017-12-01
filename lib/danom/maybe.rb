require 'danom/monad'

module Danom
  class Maybe < Monad
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
    #     Maybe([]).and_then do |value|
    #       value.each(&:some_operation)
    #       OtherModule.finalize! # <---- Side Effect should only happen
    #     end                     #       if there are any values
    #
    # The following `and_then` only executes if `value` responds truthy to any?
    #
    #     Maybe([]).continue(&:any?).and_then do |value|
    #       value.each(&:some_operation)
    #       OtherModule.finalize!
    #     end
    def continue
      and_then do |value|
        if yield value
          value
        end
      end
    end

  end
end
