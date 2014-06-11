require 'open-uri'
require 'json'

module Ruboty
  module Handlers
    class HerokuStatus < Base
      on /heroku status/, name: "heroku", description: "See Heroku Status"
      on /heroku issues/, name: "issues", description: "See Heroku Issues"
      on /heroku issue (?<id>\d+)/, name: "issue", description: "See Heroku Issue"

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

      def issue(message)
        url = "https://status.heroku.com/incidents/#{message[:id]}"
        message.reply(url)
      end

      private

      def fetch(url)
        content = open(url).read
        JSON.parse(content)
      end

    end
  end
end
