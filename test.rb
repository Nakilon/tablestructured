require "minitest/autorun"
require_relative "lib/tablestructured"

describe TableStructured do
  it do
    assert_equal \
      [{"1":4,"2":5,"3":6},{"1":7,"2":8,"3":9}],
      TableStructured.new([[1,2,3],[4,5,6],[7,8,9]], headers_up: true).map(&:to_h)
  end
end
