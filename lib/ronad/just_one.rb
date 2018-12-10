module Ronad
  # @deprecated
  # @see Ronad::Maybe::from_multiple_values
  class JustOne < Just
    def self.new(*args)
      warn "[DEPRECATION] Ronad::JustOne is deprecated, see Ronad::Many::from_multiple_values."
      raise CannotBeNil if args.compact.empty?

      Just.new Maybe.from_multiple_values(*args)
    end
  end
end
