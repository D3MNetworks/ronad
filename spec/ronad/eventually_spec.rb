require 'spec_helper'

describe Ronad::Eventually do
  it 'can delay a value' do
    val = ~ Eventually { 1 }
    expect(val).to eq 1
  end

  it 'can chain values' do
    m = Eventually { 2 } * 4
    expect(~m).to eq 8
  end

  it 'does not execute until the value is read' do
    outside_scope = nil
    m = Eventually { outside_scope = 10 }
    expect(outside_scope).to be_nil
    m = (m * 5).and_then { |v| outside_scope = v * 2 }
    expect(outside_scope).to be_nil
    ~m
    expect(outside_scope).to eq 100
  end

  it 'can be chained with other monads' do
    m = Eventually { Just 10 }
    expect(~m).to eq 10

    m = Eventually { Default(Eventually{5}, Maybe(10)) }
    expect(~m).to eq 10
    m = Eventually { Default(Eventually{5}, Maybe(nil)) }
    expect(~m).to eq 5
  end
end
