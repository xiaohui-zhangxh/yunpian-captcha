RSpec.describe Yunpian::Captcha do
  before do
    described_class.configure do |config|
      config.app_id = '450c5c58b47f423d9eb0d2412760d20e'
      config.secret_id = '18e4fb526c604adbbd56df343d84f4ec'
      config.secret_key = '328395be4c8a4148b370a3f676918b5b'
    end
  end

  it 'valid token/authenticate' do
    token = 'be0aa5e9c3814d118b000e98b48f62c5'
    authenticate = '40b9788cf38e408dab50d58e1c096fa7'
    VCR.use_cassette("authenticate-#{token}-#{authenticate}") do
      expect(described_class.verify(token, authenticate)).to be_truthy
    end
  end
end
