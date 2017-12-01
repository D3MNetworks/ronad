require 'danom/maybe'
require 'danom/just'
require 'danom/default'

def Maybe(value) ; Danom::Maybe.new(value) end
def Just(value); Danom::Just.new(value) end
def Default(fallback, value) ; Danom::Default.new(fallback, value) end

