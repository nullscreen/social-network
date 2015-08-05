Net - a Ruby client for social networks API
===========================================

Net helps you write apps that need to interact with Twitter, Instagram and Facebook.


After [configuring your Twitter app](#configuring-your-twitter-app), you can run commands like:

```ruby
user = Net::Twitter::User.find_by screen_name: 'fullscreen'
user.screen_name #=> "Fullscreen"
user.follower_count #=> 48_200
```
After [configuring your Instagram app](#configuring-your-instagram-app), you can run commands like:

```ruby
user = Net::Instagram::User.find_by username: 'fullscreen_inc'
user.username #=> "fullscreen_inc"
user.follower_count #=> 7025
```

After [configuring your Facebook app](#configuring-your-facebook-app), you can run commands like:

```ruby
page = Net::Facebook::Page.find_by username: 'fullscreeninc'
page.username #=> "fullscreeninc"
page.likes #=> 30094
```

How to install
==============

To install on your system, run

    gem install net

To use inside a bundled Ruby project, add this line to the Gemfile:

    gem 'net', '~> 0.2.1'

Since the gem follows [Semantic Versioning](http://semver.org),
indicating the full version in your Gemfile (~> *major*.*minor*.*patch*)
guarantees that your project won’t occur in any error when you `bundle update`
and a new version of Net is released.

Available resources
===================

Net::Twitter::User
------------------

Use [Net::Twitter::User]() to:

* retrieve a Twitter user by screen name
* retrieve a list of Twitter users by screen names
* access the number of followers of a Twitter user

```ruby
user = Net::Twitter::User.find_by screen_name: 'fullscreen'
user.follower_count #=> 48_200

users = Net::Twitter::User.where screen_name: ['fullscreen', 'brohemian6']
users.map(&:follower_count).sort #=> [12, 48_200]
```

*The methods above require a configured Twitter app (see below).*

Net::Instagram::User
--------------------

Use [Net::Instagram::User]() to:

* retrieve an Instagram user by username
* access the number of followers of an Instagram user
* access the number of following of an Instagram user

```ruby
user = Net::Instagram::User.find_by username: 'fullscreen'
user.follower_count #=> 7025
```

*The methods above require a configured Instagram app (see below).*

Net::Facebook::Page
--------------------

Use [Net::Facebook::Page]() to:

* retrieve a Facebook page by username
* access the number of likes of a Facebook user

```ruby
page = Net::Facebook::Page.find_by username: 'fullscreeninc'
page.likes #=> 7025
```

*The methods above require a configured Facebook app (see below).*

Configuring your Twitter app
============================

In order to use Net you must create an app in the [Twitter Application Manager](https://apps.twitter.com/app/new).

Once the app is created, copy the API key and secret and add them to your
code with the following snippet of code (replacing with your own key and secret)
:

```ruby
Net::Twitter.configure do |config|
  config.apps.push key: 'abcd', secret: 'efgh'
end
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export TWITTER_API_KEY='abcd'
export TWITTER_API_SECRET='efgh'
```

is equivalent to configuring your app with the initializer:

```ruby
Net::Twitter.configure do |config|
  config.apps.push key: 'abcd', secret: 'efgh'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `Net::Twitter.configure` takes precedence.

Configuring your Instagram app
============================

In order to use Net you must create an app in the
[Instagram Client Manager](http://instagram.com/developer/clients/register).

Once the app is created, copy the Client ID and add it to your
code with the following snippet of code (replacing with your own client id)
:

```ruby
Net::Instagram.configure do |config|
  config.client_id = 'abcdefg'
end
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
a variable. Setting the following environment variable:

```bash
export INSTAGRAM_CLIENT_ID='abcdefg'
```

is equivalent to configuring your app with the initializer:

```ruby
Net::Instagram.configure do |config|
  config.client_id = 'abcdefg'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `Net::Instagram.configure` takes precedence.

Configuring your Facebook app
============================

In order to use Net you must create an app in the [Facebook Application Manager](https://developers.facebook.com/apps/).

Once the app is created, copy the API key and secret and add them to your
code with the following snippet of code (replacing with your own key and secret)
:

```ruby
Net::Facebook.configure do |config|
  config.client_id = 'abcdefg'
  config.client_secret = 'abcdefg'
end
```

Configuring with environment variables
--------------------------------------

As an alternative to the approach above, you can configure your app with
variables. Setting the following environment variables:

```bash
export FACEBOOK_CLIENT_ID='abcd'
export FACEBOOK_CLIENT_SECRET='efgh'
```

is equivalent to configuring your app with the initializer:

```ruby
Net::Facebook.configure do |config|
  config.client_id = 'abcd'
  config.client_secret = 'efgh'
end
```

so use the approach that you prefer.
If a variable is set in both places, then `Net::Facebook.configure` takes precedence.

How to test
===========

To run tests, type:

```bash
rspec
```

Net uses [VCR](https://github.com/vcr/vcr) so by default tests do not run
HTTP requests.

If you need to run tests against the live Twitter API or Instagram API,
configure your [Twitter app](#configuring-your-twitter-app) or your [Instagram app](#configuring-your-instagram-app)  using environment variables,
erase the cassettes, then run `rspec`.


How to release new versions
===========================

If you are a manager of this project, remember to upgrade the [Net gem](http://rubygems.org/gems/net)
whenever a new feature is added or a bug gets fixed.

Make sure all the tests are passing, document the changes in CHANGELOG.md and
README.md, bump the version, then run

    rake release

Remember that the net gem follows [Semantic Versioning](http://semver.org).
Any new release that is fully backward-compatible should bump the *patch* version (0.1.x).
Any new version that breaks compatibility should bump the *minor* version (0.x.0)
