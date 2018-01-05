require 'sugar'

describe Ronad::Default do
  it 'provides a default if the value turns out to be nil' do
    fallback = 'hello'
    d = Default fallback, nil
    expect(d.upcase.value).to eq fallback
  end

  it 'throws an error if you provide a nil for the fallback' do
    expect{
      d = Default nil, 'hello'
    }.to raise_error(Ronad::Just::CannotBeNil)
  end

  it 'can be combined with other monads' do
    d = Default "not found", Maybe( 'start' )
    expect(d.upcase.split('').join('.').value).to eq 'S.T.A.R.T'

    d = Default "not found", Maybe(nil)
    expect(d.upcase.split('').join('.').value).to eq 'not found'
  end


end
