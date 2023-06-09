module TableStructured
  Error = Class.new RuntimeError
  def self.new object, headers: :top, drop_first: 0, drop_last: 0  # TODO: headers_left should probably mean the ids of entries
    if object.nil?
      raise ArgumentError, "passed object can be an Array or Ferrum Node, but not Nil"
    elsif object.respond_to? :css
      # the xml object ignores the :headers arg for now
      names = if :top == headers
        object
      elsif headers.respond_to? :css
        headers
      else
        fail "invalid type of headers"
      end.css("thead th")[drop_first..-1-drop_last].map do |_|
        _.text.sub(/\A[[[:space:]]]*/,"").sub(/[[[:space:]]]*\z/,"")
      end
      t = names.group_by(&:itself).map{ |k, g| [k, g.size.times.to_a] if 1 < g.size }.compact.to_h
      names = names.map{ |_| if i = t[_]&.shift then "#{_}_#{i+1}" else _ end.to_sym }
      struct = begin
        Struct.new *names
      rescue NameError
        raise $!.exception "#{$!}: #{names.inspect}"
      end
      require "timeout"
      object.css("tbody > tr").map do |row|
        tds = []
        Timeout.timeout 5 do
          tds = [row.css("th"), *row.css("td")][drop_first..-1-drop_last]
          if tds.empty?
            STDERR.puts "empty row"
            sleep 0.1
            redo
          end
        end
        raise Error, "size mismatch (#{names.size} headers (#{names}), #{tds.size} row items)" if tds.size != names.size
        struct.new *tds
      end
    else
      struct = Struct.new *(headers == :top ? object.first : headers).map(&:to_s).map(&:to_sym).tap{ |_| fail "headers should be unique" if _.uniq! }
      object.drop(headers == :top ? 1 : 0).map{ |_| struct.new *_ }
    end
  end
end
