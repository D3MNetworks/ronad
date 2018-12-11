require 'ronad/maybe'
require 'ronad/many'
require 'ronad/one'
require 'ronad/just'
require 'ronad/just_one'
require 'ronad/default'
require 'ronad/eventually'

def Maybe(*values) ; Ronad::Maybe.from_multiple_values(*values) end
def Many(value, **kargs) ; Ronad::Many.new(value, **kargs) end
def One(value, **kargs) ; Ronad::One.new(value, **kargs) end
def Just(value); Ronad::Just.new(value) end
def JustOne(*values); Ronad::JustOne.new(*values) end
def Default(fallback, value) ; Ronad::Default.new(fallback, value) end
def Eventually(&b); Ronad::Eventually.new(b) end

