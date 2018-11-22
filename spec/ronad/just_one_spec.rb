require 'spec_helper'

describe Ronad::JustOne do
  it 'throws CannotBeNil if a nil is initialized' do
    expect{ JustOne(nil) }.to raise_error(Ronad::JustOne::CannotBeNil)
  end

  it 'can be initialized with non-nil values' do
    number = JustOne 5
    expect(number.value).to eq 5
  end

  it 'can chain methods' do
    number = JustOne(5).to_s
    expect(number.value).to eq 5.to_s
  end

  it 'will raise CannotBeNil if it chains into a nil' do
    expect {  JustOne({})[:occupation] }.to raise_error(Ronad::JustOne::CannotBeNil)
  end

  it 'can be comined with other monads' do
    expect { ~JustOne(Maybe(nil)) }.to raise_error(Ronad::JustOne::CannotBeNil)
  end

  it 'can be combined with other monads and return their value' do
    val = 5

    expect(~JustOne(Maybe(val))).to eq val
  end

  it 'can take multiple arguments, returning the first that is not null' do
    j = Just(5)
    m = JustOne(nil, Maybe(nil), j, 10)
    expect(m.value).to eq j.value
  end
end

