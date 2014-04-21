# Omniauth Strategy for Lumo
This is a strategy to connect with Lumo using Ommniauth and OAuth 2.0. Originally written by [andrewfree](https://github.com/andrewfree), up to date as of Feb 13, 2014 for Lumo's API.

## Usage

`OmniAuth::Strategies::Lumo` is a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :lumo, ENV['KEY'], ENV['SECRET']
end
```