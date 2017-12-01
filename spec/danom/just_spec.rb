require 'spec_helper'

describe Danom::Just do
  it 'throws CannotBeNil if a nil is initialized' do
    expect{ Just(nil) }.to raise_error(Danom::Just::CannotBeNil)
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
    expect {  Just({})[:occupation] }.to raise_error(Danom::Just::CannotBeNil)
  end
end
