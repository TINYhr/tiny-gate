$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tiny_gate'
require_relative 'support/vcr'

RSpec.configure do |config|
  config.around(:each, with_vcr: true) do |example|
    with_vcr_cassette(example, preserve_exact_body_bytes: true)
  end
end
