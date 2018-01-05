module Ronad
  # Delayed execution. Similar to creating a closure but Eventually is
  # compatible with the Ronad API.
  #
  # Eventually is not a promise. The block in the Eventually will not execute
  # until invoked.
  class Eventually < Monad
    def initialize block
      @value = block
    end

    # @override
    def and_then &block
      new_block = lambda do
        block.call(expand @value.call)
      end

      Eventually.new new_block
    end

    # @override
    def monad_value
      expand @value.call
    end

    # @note can probably replace monad_value
    def expand(val)
      if Monad === val
        expand val.monad_value
      else
        val
      end
    end
  end
end
