module TableStructured
  def self.new object, headers: :top  # TODO: headers_left should probably mean the ids of entries
    if object.respond_to? :css
      # the xml object ignores the :headers arg for now
      struct = Struct.new *object.at_css("thead").css("th").map(&:text).map(&:to_sym).tap{ |_| fail "headers should be unique" if _.uniq! }
      object.css("tr").drop(1).map{ |_| struct.new *_.css("td") }
    else
      struct = Struct.new *object.first.map(&:to_s).map(&:to_sym).tap{ |_| fail "headers should be unique" if _.uniq! }
      object.drop(1).map{ |_| struct.new *_ }
    end
  end
end
