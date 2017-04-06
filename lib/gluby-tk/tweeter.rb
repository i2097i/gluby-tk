require 'twitter'
module GlubyTK
  class Tweeter
    ENV_VAR_KEYS = [
      "CONSUMER_KEY",
      "COMSUMER_KEY_SECRET",
      "ACCESS_TOKEN",
      "ACCESS_SECRET"
    ]
    def self.tweet_release
      unless ENV_VAR_KEYS.select{|k| !ENV[k].nil? }.count != ENV_VAR_KEYS.count
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV["CONSUMER_KEY"]
          config.consumer_secret     = ENV["COMSUMER_KEY_SECRET"]
          config.access_token        = ENV["ACCESS_TOKEN"]
          config.access_token_secret = ENV["ACCESS_SECRET"]
        end
        client.update("#{GlubyTK::VERSION} changes: #{GlubyTK::RELEASE_NOTES}")
      end
    end
  end
end