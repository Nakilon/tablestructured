module TableStructured
  def self.new array, headers_up: false#, headers_left: false
    # TODO: headers_left should probably mean the ids of entries
    struct = Struct.new *array.first.map(&:to_s).map(&:to_sym).tap{ |_| fail "headers should be unique" if _.dup.uniq! }
    array.drop(1).map{ |_| struct.new *_ }
  end
end
