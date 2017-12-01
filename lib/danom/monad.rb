module Danom
  class Monad
    def initialize(value)
      if Monad === value
        @value = value.value
      else
        @value = value
      end
    end

    def value
      if Monad === @value
        @value.value
      else
        @value
      end
    end

    # to_s does not get caught by method_missing
    def to_s
      and_then { |v| v.to_s }
    end

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
