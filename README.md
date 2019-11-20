# YunPian Captcha

Ruby Client for YunPian.com Captcha service https://www.yunpian.com/doc/zh_CN/captcha/captcha_service.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yunpian-captcha'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yunpian-captcha

## Usage

```ruby
# config/initializers/yunpian.rb
Yunpian::Captcha.configure do |config|
  config.app_id = ENV['YUNPIAN_CAPTCHA_APP_ID']
  config.secret_id = ENV['YUNPIAN_CAPTCHA_SECRET_ID']
  config.secret_key = ENV['YUNPIAN_CAPTCHA_SECRET_KEY']
end

# app/controllers/sessions_controller.rb

def create
  if Yunpian::Captcha.verify(params[:captcha_token], params[:captcha_authenticate])
    # verify username/password
    # sign_in!
  else
    flash[:alert] = 'invalid captcha'
    render :new
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiaohui-zhangxh/yunpian-captcha.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
