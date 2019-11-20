require "yunpian/captcha/version"
require 'yunpian/captcha/auth_service'
module Yunpian
  module Captcha
    Configuration = Struct.new(:app_id, :secret_id, :secret_key, :exception_recorder, :logger)
    API_URI = URI('https://captcha.yunpian.com/v1/api/authenticate')

    class << self
      def config
        @config ||= Configuration.new
      end

      def configure
        yield config
      end

      def verify(token, authenticate)
        Yunpian::Captcha::AuthService.new(token, authenticate, config).call
      end
    end
  end
end
