# Omniauth::Doximity

Omniauth Strategy for Doximity. Find out more about Doximity at doximity.com

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-doximity', git: 'https://github.com/huyha85/omniauth-doximity'

And then execute:

    $ bundle

## Usage

You need to add the following to your `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :doximity, "consumer_key", "consumer_secret", redirect_uri: "redirect_uri"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
