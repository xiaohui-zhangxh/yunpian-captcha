require 'logger'
RSpec.describe Yunpian::Captcha::AuthService do
  let(:config) do
    Yunpian::Captcha::Configuration.new.tap do |config|
      config.app_id = '450c5c58b47f423d9eb0d2412760d20e'
      config.secret_id = '18e4fb526c604adbbd56df343d84f4ec'
      config.secret_key = '328395be4c8a4148b370a3f676918b5b'
      # config.logger = Logger.new(STDOUT)
      # config.exception_recorder = proc { |result| puts result }
    end
  end

  let(:token) { 'e0ca7db24e7946a5a300ddb998eaf61a' }
  let(:authenticate) { '692a152742364fd5a3d2b265c738723d' }
  let(:time_now) { Time.at(1574262708) }
  let(:unsigned_params) do
    {
      captchaId: config.app_id,
      token: token,
      authenticate: authenticate,
      secretId: config.secret_id,
      version: "1.0",
      timestamp: (time_now.to_f * 1000).to_i,
      nonce: 83210
    }
  end
  let(:signature) { "d216e8474607035f18f41146ac687d6d" }
  let(:signed_params) { unsigned_params.merge(signature: signature) }
  let(:service) { described_class.new(token, authenticate, config) }

  before do
    allow(Time).to receive(:now).and_return(time_now)
    Random.srand(10)
  end

  it 'valid token/authenticate #1' do
    token = 'be0aa5e9c3814d118b000e98b48f62c5'
    authenticate = '40b9788cf38e408dab50d58e1c096fa7'
    VCR.use_cassette("authenticate-#{token}-#{authenticate}") do
      service = Yunpian::Captcha::AuthService.new(token, authenticate, config)
      expect(service.call).to be_truthy
    end
  end

  it 'valid token/authenticate #2' do
    token = 'b951b9f258694780b63f98db61e244a8'
    authenticate = '975cf795a091403e95edb98f0736e783'
    VCR.use_cassette("authenticate-#{token}-#{authenticate}") do
      service = Yunpian::Captcha::AuthService.new(token, authenticate, config)
      expect(service.call).to be_truthy
    end
  end

  it 'invalid token/authenticate #3' do
    token = 'b951b9f258694780b63f98db61e244a8'
    authenticate = 'fake-string'
    VCR.use_cassette("authenticate-#{token}-#{authenticate}") do
      service = Yunpian::Captcha::AuthService.new(token, authenticate, config)
      expect(service.call).to be_falsy
    end
  end

  it 'build_params returns as expected' do
    expect(service.send(:build_params)).to match(unsigned_params)
  end

  it 'signature returns as expected' do
    expect(service.send(:signature, unsigned_params)).to eq signature
  end
end
