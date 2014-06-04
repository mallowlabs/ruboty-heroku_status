require 'open-uri'
require 'json'

module Ruboty
  module Handlers
    class HerokuStatus < Base
      on /heroku status/, name: "heroku", description: "See Heroku Status"

      def heroku(message)
        content = open("https://status.heroku.com/api/v3/current-status").read
        json = JSON.parse(content)
        body = <<MESSAGE
Production: #{json["status"]["Production"]}
Development: #{json["status"]["Development"]}
MESSAGE
        message.reply(body)
      end

    end
  end
end
