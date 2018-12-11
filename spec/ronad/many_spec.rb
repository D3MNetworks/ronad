require 'spec_helper'

describe Ronad::Many do
  it 'wraps single values and returns an Enumerable for its value' do
    m = Many 5
    expect(m.value).to be_a Enumerable
  end

  it 'applies the and_then transformation to each element' do
    names = %w[lucy jill]
    name = Many names

    scream = name.upcase + '!'

    expect(scream.value).to include 'JILL!'
    expect(scream.value).to include 'LUCY!'
  end

  it 'flattens nested values' do
    sentence = 'dashes-are in-this cool-sentence'
    word = Many(sentence)
      .split(' ')
      .split('-')

    expect(word.value).to eq %w{dashes are in this cool sentence}
  end

  it 'filters results that return nil' do
    names = %{henrietta stacey holly}
    name = Many names
    h_names_fn = -> (name) { name =~ /^h/i }
    h_names = h_names_fn.call name
    expect(h_names.value).not_to include 'stacey'
  end

  it 'returns an array by default' do
    m = Many [1]
    expect(m.value).to eq [1]
  end

  it 'wraps elements in arrays' do
    m = Many 1
    expect(m.value).to eq [1]
  end

  it 'returns a Enumerator::Lazy if one is provided' do
    m = Many [1].lazy
    expect((m + 2).value).to be_a Enumerator::Lazy
  end

  it 'can return a Enumerator::Lazy if the option is specified' do
    m = Many 1, return_lazy: true
    expect(m.monad_value).to be_a Enumerator::Lazy
  end
end
