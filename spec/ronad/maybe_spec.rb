require 'spec_helper'

describe Ronad::Maybe do
  it 'chains nils together' do
    # The assertion is that there is no error
    Maybe(nil).m1.m2.m3
  end

  it 'can retrieve the value' do
    v = "1"
    m = Maybe(v).to_i
    expect(m.value).to eq v.to_i
  end

  it 'unwraps other monads' do
    str = '999'
    m = Maybe( Maybe( Maybe( str ) ) ).to_i
    expect( m.value ).to eq str.to_i
  end

  it 'overrides #to_s' do
    i = 1
    m = Maybe(i).to_s
    expect(m.value).to eq i.to_s
  end

  describe '#and_then' do
    it 'chains operations together' do
      m = Maybe(1).and_then(&:to_s)
      expect(m.value).to eq "1"

      m = Maybe(2).and_then do |value|
        value * 2
      end

      expect(m.value).to eq 4
    end

    it 'sets the last value as the new value of the maybe' do
      response = {person: {name: 'bob', age: 100}}

      m = Maybe(response)
      m = m.and_then do |person|
        person[:person][:age] = 50
      end
      expect(m.value).to eq 50

      m = Maybe(response)
      m = m.and_then do |person|
        person[:person][:age] = 50
        person
      end
      expect(m.value[:person][:age]).to eq 50
    end
  end

  describe '#continue' do
    it '"Fails" the Maybe' do
      m = Maybe(1).continue{false}
      expect(m.value).to be_nil
    end

    it 'can be used to short-circuite normally truthy operations' do
      side_effect = nil
      Maybe([]).and_then do |v|
        side_effect = v.map(&:to_s)
      end
      expect(side_effect).to eq []


      side_effect = nil
      Maybe([]).continue(&:any?).and_then do |v|
        side_effect = v.map(&:to_s)
      end
      expect(side_effect).to be_nil
    end

    it 'has no effect if the maybe is already a nil' do
      side_effect = nil
      Maybe(nil).continue{true}.and_then do |v|
        side_effect = 11
      end

      expect(side_effect).to be_nil
    end

    it 'can be chained like and_then' do
      even = ->(array) { array.all?(&:even?) }
      sum = ->(memo, i) { memo + i }

      m = Maybe([6,2])
        .continue(&:any?)
        .continue(&even)
        .reduce(&sum)
      expect(m.value).to eq 8

      m = Maybe([1,2])
        .continue(&:any?)
        .continue(&even)
        .reduce(&sum)
      expect(m.value).to be_nil

      m = Maybe(nil)
        .continue(&:any?)
        .continue(&even)
        .reduce(&sum)
      expect(m.value).to be_nil
    end
  end


  describe '#halt' do
    it '"Fails" the Maybe' do
      m = Maybe(1).halt{true}
      expect(m.value).to be_nil
    end

    it 'can be used to short-circuite normally truthy operations' do
      side_effect = nil
      Maybe([]).and_then do |v|
        side_effect = v.map(&:to_s)
      end
      expect(side_effect).to eq []


      side_effect = nil
      Maybe([]).halt(&:empty?).and_then do |v|
        side_effect = v.map(&:to_s)
      end
      expect(side_effect).to be_nil
    end

    it 'has no effect if the maybe is already a nil' do
      side_effect = nil
      Maybe(nil).halt{false}.and_then do |v|
        side_effect = 11
      end

      expect(side_effect).to be_nil
    end
  end

end
