module TableStructured
  def self.new object, headers: :top, drop: 0  # TODO: headers_left should probably mean the ids of entries
    if object.respond_to? :css
      # the xml object ignores the :headers arg for now
      ss = if :top == headers
        object
      elsif headers.respond_to? :css
        headers
      else
        fail "invalid type of headers"
      end.css("th").drop(drop).map{ |_| _.text.sub(/\A[[[:space:]]]*/,"").sub(/[[[:space:]]]*\z/,"").to_sym }
      struct = begin
        Struct.new *ss
      rescue NameError
        raise $!.exception "#{$!}: #{ss.inspect}"
      end
      object.css("tbody>tr").map{ |_| struct.new *_.css("td").drop(drop) }
    else
      struct = Struct.new *object.first.map(&:to_s).map(&:to_sym).tap{ |_| fail "headers should be unique" if _.uniq! }
      object.drop(1).map{ |_| struct.new *_ }
    end
  end
end
