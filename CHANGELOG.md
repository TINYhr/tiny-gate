# v1.0.0 2018-06-17

## BREAKING CHANGES

* Upgrade `dry-struct` to version `0.5.0`, drop support for version `0.4.0`
and lower
* `TinyGate::TestHelper::User#add_permission` must be called before requesting to server
* `TinyGate::TestHelper::User#current_permission` is first permission of signed in organization
* `UserClient.add_user` returns new user’s token instead of the whole user

[Compare 0.6.1...1.0.0](https://github.com/tinyhr/tiny-gate/compare/0.6.1...1.0.0)
