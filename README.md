# Ronad

[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/D3MNetworks/ronad)

Monads implemented in Ruby with sugar. Inspired by [@tomstuart](https://twitter.com/tomstuart)'s
talk https://codon.com/refactoring-ruby-with-monads

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ronad', require: 'ronad/sugar'
```

Alernatively without sugar

```ruby
gem 'ronad'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ronad

## Sugar

If required, you can use the monads as methods:

```ruby
Maybe('hello')
Just('world')
Default('hello', 'world')
```

Without the sugar you must use the fully qualified name and invoke the constructor:

```ruby
Ronad::Maybe.new('hello')
Ronad::Just.new('world')
Ronad::Default.new('hello', 'world')
```

All examples will be using the "sugar" syntax but they are interchangeable.


## Usage

Generally every `Ronad::Monad` will respond to `and_then`.

`method_missing` is also used to for convenience as a proxy for `and_then`.

```ruby
maybe_name = Maybe({person: {name: 'Bob'}})
maybe_name
  .and_then{ |v| v[:person] }
  .and_then{ |v| v[:name] }
  .value

# Equivalent:

maybe_name = Maybe({person: {name: 'Bob'}})
~maybe_name[:person][:name]
```


Generally the `and_then` block will only run based on a condition from the specific monad.

For example, `Maybe` will only invoke the block from `and_then` if the underlying value is not

`nil`.

```ruby
Maybe(nil).and_then do |_|
  raise "Boom"
end #=> No error
```


### `value`, `monad_value`, `~`

To get the underlying value of a monad you need to call `#value`. If the underlying value also
responds to `#value`, you can use `#monad_value`. `#~` is a unary operator overload which is an
alias for `monad_value`.

```ruby
m = Maybe(5)

m.value == m.monad_value #=> true
m.value == ~m #=> true
m.monad_value == ~m #=> true
```

## Maybe

`Maybe` is useful as a safe navigation operator:

```ruby
response = request(params) #=> {}
name  = ~Maybe(response[:person])[:name] #=> nil
```

It's also useful as an annotation. If you look at the previous example, you'll notice that you could
wrap `response` in a maybe instead:

```ruby
name = ~Maybe(response)[:person][:name] #=> nil
```

This functionally the same but has different semantics. With the former example, it has correctly
annotated that `response[:person]` can be `nil`, whereas the latter example is an over eager usage.



Here's a less trivial example

```ruby
Document.each do |doc|
  maybe_json = Maybe(doc.data) # data is nil or a json string
    .and_then{|str| JSON.parse str}

  maybe_json['nodes'] # method_missing in action
    .map do |n|
      n['new_field'] = 'new'
      n
    end
    .continue(&:any?) # see documentation
    .and_then do |new_nodes|
      doc.data['nodes'] = new_nodes
      doc.save!
    end
end
```

In this example `value` was no invoked as `Maybe` was use more so for flow control.

## Just

Useful for catching a nil immediately

```ruby
Just(nil) #=> Ronad::Just::CannotBeNil
never_nil = Just(5).and_then { nil }  #=> Ronad::Just::CannotBeNil
good = ~Just(5) #=> 5
```

## Default

Similar to a null object pattern. Setting up defaults so `#value` will never return nil. Can be
combined with a `Maybe`.

```ruby
d = ~Default('hello', nil) #=> 'hello'
d = ~Default('hello', Maybe(10)) #=> 10
```

Notice that default will recursively expand other Monads. As a general rule, you should never
receive a monad after invoking `#value`.

## Eventually

Useful for delaying execution or not executing at all. Useful to combine with
Default when it's not know if the default should execute.

```
person = Default(
  Eventually { Person.create(name: "Frank", location: :unknown) },
  Maybe(Person.find_by(name: "Frank"))
)

~ person.update(location: 'somewhere')
```

If `find_by` finds a person the `Person.create` will never be invoked.
Conversely if `find_by` does not it will create the person and update their
location.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
