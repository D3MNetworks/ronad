require 'ronad/maybe'
require 'ronad/just'
require 'ronad/default'

def Maybe(value) ; Ronad::Maybe.new(value) end
def Just(value); Ronad::Just.new(value) end
def Default(fallback, value) ; Ronad::Default.new(fallback, value) end

