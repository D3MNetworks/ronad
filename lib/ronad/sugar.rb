require 'ronad/maybe'
require 'ronad/just'
require 'ronad/just_one'
require 'ronad/default'
require 'ronad/eventually'

def Maybe(value) ; Ronad::Maybe.new(value) end
def Just(value); Ronad::Just.new(value) end
def JustOne(*values); Ronad::JustOne.new(*values) end
def Default(fallback, value) ; Ronad::Default.new(fallback, value) end
def Eventually(&b); Ronad::Eventually.new(b) end

