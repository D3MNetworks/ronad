require 'spec_helper'

describe Ronad::Just do
  it 'throws CannotBeNil if a nil is initialized' do
    expect{ Just(nil) }.to raise_error(Ronad::Just::CannotBeNil)
  end

  it 'can be initialized with non-nil values' do
    number = Just 5
    expect(number.value).to eq 5
  end

  it 'can chain methods' do
    number = Just(5).to_s
    expect(number.value).to eq 5.to_s
  end

  it 'will raise CannotBeNil if it chains into a nil' do
    expect {  Just({})[:occupation] }.to raise_error(Ronad::Just::CannotBeNil)
  end

  it 'can be comined with other monads' do
    expect { ~Just(Maybe(nil)) }.to raise_error(Ronad::Just::CannotBeNil)
  end

  it 'can be combined with other monads and return their value' do
    val = 5

    expect(~Just(Maybe(val))).to eq val
  end
end
