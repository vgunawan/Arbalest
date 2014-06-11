module Arbalest
  module Parsers
    class MT4
      def self.parse(csv)
        return nil if csv.size < 6
        datetime = csv[0..1].join('T').gsub(/[\.]/,'-')
        h = {
          timestamp: Time.parse(datetime).to_i,
          o: csv[2].to_f,
          h: csv[3].to_f,
          l: csv[4].to_f,
          c: csv[5].to_f
        }
        if csv[6]
          h[:v] = csv[6].to_i
        end
        h
      end
    end
  end
end
