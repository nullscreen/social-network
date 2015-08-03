require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/support/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('TWITTER_API_KEY') { Net::Twitter.configuration.apps.first[:key] }
  c.filter_sensitive_data('TWITTER_API_SECRET') { Net::Twitter.configuration.apps.first[:secret] }
  c.filter_sensitive_data('INSTAGRAM_CLIENT_ID') { Net::Instagram.configuration.client_id }
  c.filter_sensitive_data('FACEBOOK_CLIENT_ID') { Net::Facebook.configuration.client_id }
  c.filter_sensitive_data('FACEBOOK_CLIENT_SECRET') { Net::Facebook.configuration.client_secret }
  c.filter_sensitive_data('ACCESS_TOKEN') do |interaction|
    if interaction.request.uri.include? "twitter"
      if interaction.request.headers['Authorization']
        interaction.request.headers['Authorization'].first
      else
        JSON(interaction.response.body)['access_token']
      end
    end
  end
  c.filter_sensitive_data(12345678) do |interaction|
    if interaction.response.status.code == 429
      interaction.response.headers['X-Rate-Limit-Reset'].first
    end
  end
  c.ignore_hosts 'graph.facebook.com'
end
