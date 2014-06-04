require 'open-uri'
require 'json'

module Ruboty
  module Handlers
    class HerokuStatus < Base
      on /heroku status/, name: "heroku", description: "See Heroku Status"
      on /heroku issues/, name: "issues", description: "See Heroku Issues"

      def heroku(message)
        json = fetch("https://status.heroku.com/api/v3/current-status")
        body = <<MESSAGE
Production: #{json["status"]["Production"]}
Development: #{json["status"]["Development"]}
MESSAGE
        message.reply(body)
      end

      def issues(message)
        json = fetch("https://status.heroku.com/api/v3/issues?limit=5")
        body = json.map { |issue|
          resolved = issue['resolved'] ? "(resolved)" : "(unresolved)"
          "#{issue['id']}: #{issue['title']} #{resolved}"
        }.join("\n")
        message.reply(body)
      end

      private

      def fetch(url)
        content = open(url).read
        json = JSON.parse(content)
      end

    end
  end
end
