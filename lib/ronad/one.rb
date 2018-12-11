module Ronad
  # A One is similar to a Many but does not flatten the results if #and_then
  # produces another list.
  #
  #     urls = %w[
  #       example.com?p1=a&p2=b
  #       example.com?z1=5&y1=9
  #     ]
  #
  #     one(urls)
  #       .split('?')
  #       .last # a Many would have flatten the #split and #last would be called on a String
  #       .split('&')
  #       .last
  #       .split('=')
  #       .first
  #       .value #=> ['p2', 'y1']
  #
  # A One can be used for providing a familiar interface to a function that
  # does not expect the flattening behavior of Many.
  class One < Many
    def and_then &b
      from_value @value.reject(&:nil?).map(&b)
    end
  end
end
