# encoding: utf-8

require 'json'

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
        json = JSON.load request.body.string
        msg = ""

        f = false
        count = json["count"] || 0

        json["text"].each_line do |line|
          if /#{json["pattern"]}/ =~ line
            f = true
          end

          if f == true and count > 0
            msg << line
            count -= 1
          else
            f = false
            count = json["count"] || 0
          end
        end

        if !msg.empty?
          robot.send_message(@source, msg)
        end
      rescue => e
        robot.send_message(@source, e.backtrace)
      end

      Lita.register_handler(self)
    end
  end
end
