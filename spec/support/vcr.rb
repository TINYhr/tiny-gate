require 'vcr'

VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = File.expand_path(File.dirname(__FILE__) + '/../fixtures/vcr')
  c.hook_into :webmock

  c.default_cassette_options = { :serialize_with => :json, :match_requests_on => [:method, :uri, :body] }

  # For character encoding issues.
  c.before_record(:base64_response_body) do |interaction|
    interaction.response.body = Base64.encode64(interaction.response.body)
  end

  c.before_playback(:base64_response_body) do |interaction|
    interaction.response.body = Base64.decode64(interaction.response.body)
  end
end
