module TableStructured
  Error = Class.new RuntimeError
  def self.new object, headers: :top, drop_first: 0, drop_last: 0  # TODO: headers_left should probably mean the ids of entries
    if object.nil?
      raise ArgumentError, "passed object can be an Array or Ferrum Node, but not Nil"
    elsif object.respond_to? :css
      # the xml object ignores the :headers arg for now
      ss = if :top == headers
        object
      elsif headers.respond_to? :css
        headers
      else
        fail "invalid type of headers"
      end.css("th")[drop_first..-1-drop_last].map{ |_| _.text.sub(/\A[[[:space:]]]*/,"").sub(/[[[:space:]]]*\z/,"").to_sym }
      struct = begin
        Struct.new *ss
      rescue NameError
        raise $!.exception "#{$!}: #{ss.inspect}"
      end
      object.css("tbody>tr").map do |_|
        tds = []
        Timeout.timeout 2 do
          tds = _.css("td")[drop_first..-1-drop_last]
          if tds.empty?
            STDERR.puts "empty row"
            sleep 0.1
            redo
          end
        end
        raise Error, "size mismatch (#{ss.size} headers, #{tds.size} row items)" if tds.size != ss.size
        struct.new *tds
      end
    else
      struct = Struct.new *(headers == :top ? object.first : headers).map(&:to_s).map(&:to_sym).tap{ |_| fail "headers should be unique" if _.uniq! }
      object.drop(headers == :top ? 1 : 0).map{ |_| struct.new *_ }
    end
  end
end
