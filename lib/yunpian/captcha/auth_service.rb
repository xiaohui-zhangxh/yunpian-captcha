require 'digest/md5'
require 'net/http'
require 'json'
module Yunpian::Captcha
  class AuthService
    PARAMS = %w[captchaId token authenticate secretId version user timestamp nonce signature]

    attr_reader :token, :authenticate, :config
    def initialize(token, authenticate, config = Yunpian::Captcha.config)
      @config, @token, @authenticate = config, token, authenticate
    end

    def call
      log :debug, 'verifying'
      signed_params = sign(build_params)
      valid?(signed_params)
    end

    private

    def valid?(signed_params)
      log :debug, "signed params is #{signed_params}"
      resp = Net::HTTP.post_form(API_URI, signed_params)
      log :debug, "API response => #{resp.body}"
      result = JSON.parse(resp.body) rescue nil
      return true if result && result['code'].zero?

      record_exception!(result)
      false
    end

    def sign(params)
      params.tap do |p|
        p[:signature] = signature(params)
      end
    end

    def signature(params)
      str = params.sort.inject("") { |ret, kv| ret << kv.join }
      str << config.secret_key
      Digest::MD5.hexdigest(str)
    end

    def build_params
      {
        captchaId: config.app_id,
        token: token,
        authenticate: authenticate,
        secretId: config.secret_id,
        version: '1.0',
        timestamp: (Time.now.to_f * 1000).to_i,
        nonce: rand(1..99_999)
      }
    end

    def log(type, message)
      return unless logger

      logger.send type,
                  "[YunPian Captcha][token=#{token}, " \
                  "authenticate=#{authenticate}] " \
                  "#{message}"
    end

    def logger
      @logger ||= config.logger
    end

    def record_exception!(result)
      config.exception_recorder&.call(result)
    end
  end
end
