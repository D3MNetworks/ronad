module Ronad
  class JustOne < Just
    def initialize(*args)
      super args.detect { |v| Monad === v ? v.value : v }
    end
  end
end
