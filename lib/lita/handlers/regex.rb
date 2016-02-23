module Lita
  module Handlers
    class Regex < Handler
      config :channel_name

      http.post "/regex", :regex

      def initialize(robot)
        super
        room = Lita::Room.find_by_name config.channel_name
        @source = Lita::Source.new(room: room)
      end

      def regex(request, response)
        arr = request.body.string.gsub(/(?:\\n|\n)/, " ").split(" ")

        str = arr.slice(0, arr.size-2)
        count = is_numeric?(arr[-1]) ? arr[-1].to_i : 0
        pattern = arr[-2] || ""
        msg = ""

        f = false

        str.each do |line|
          if line[pattern]
            f = true
          end

          if f == true and count > 0
            msg << line << "\n"
            count -= 1
          else
            f = false
            count = count || 0
          end
        end

        if !msg.empty?
          robot.send_message(@source, msg.force_encoding("utf-8"))
        end
      rescue => e
        robot.send_message(@source, e.message)
      end

      def is_numeric?(obj)
        obj.to_s.match(/\A\d+\z/) == nil ? false : true
      end

      Lita.register_handler(self)
    end
  end
end
