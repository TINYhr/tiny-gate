# TinyGate

[![Build Status](https://travis-ci.org/TINYhr/tiny-gate.svg?branch=master)](https://travis-ci.org/TINYhr/tiny-gate)

This is a simple authentication client for all TINYpulse applications. This is
the gateway of everything, hence the name :P

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tiny-gate'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install tiny-gate
```

## Usage

### Configuration

```ruby
require 'tiny_gate'

TinyGate::Client.configurate do |config|
  config.app_id = ENV['APP_ID']
  config.root_url = ENV['AUTHENTICATION_ROOT_URL']
end
```

### Initialize

```ruby
require 'tiny_gate'

client = TinyGate::Client.new
# or
client = TinyGate::Client.new(ENV['AUTHENTICATION_ROOT_URL'], ENV['APP_ID'])
```

### Get login and logout url

```ruby
client.login_url
client.logout
```

### Validate a validation ticket

```ruby
result = client.validate(ticket: ticket)

if result.success?
  login(result.global_user)
else
  # send error message
end
```

### Check signed in status

```ruby
client.signed_in?(token, user_id)
```

### Get current user

```ruby
result = client.fetch_user(token, user_id)

if result.success?
  user = result.global_user
  puts user.email
  puts user.id
  puts user.token
  puts user.active_permissions
else
  # send error message
end
```

## Testing with Cucumber


### Preparation

```ruby
# Add to gemfile

group :test do
  gem 'sinatra'
  gem 'daemons'
end
```

### Interact using capybara & site_prism

```ruby
class SignIn < SitePrism::Page
  set_url "/login"

  element :email_field, "input.form-control[name='session[email]']"
  element :password_field, "input.form-control[name='session[password]']"
  element :login_button, "button.btn-success"
end
```

### Create user & permission

User needs to have at least one permission before login. First permission will be used to determine current organization.

```ruby
client.add_user(id: global_user_id, email: user_email, passsword: password)

# First permission is required
client.add_permission(
  user_id: global_user_id,
  role_id: global_role_id,
  permission_id: global_permission_id,
  organization_id: global_organization_id,
  organization_name: global_organization_name, # nil if ommitted
  app_id: app_id # nil if omitted
)
```

### Start server

```ruby
# in env.rb

require 'tiny_gate/test_helper'

After do |scenario|
  TinyGate::TestHelper.stop_server
end

AfterConfiguration do
  TinyGate::TestHelper.start_server
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TINYhr/tiny-gate.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
