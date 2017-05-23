require 'spec_helper'
require 'tiny_gate/test_helper/user_client'

describe TinyGate::TestHelper::UserClient do
  describe '#add_user' do
    let(:url) { 'root_url' }
    let(:payload) { 'payload' }
    let(:client) { described_class.new(url) }
    let(:response) { double('Response', body: "{}") }

    it 'calls add user api' do
      expect(HTTP).to receive(:post)
        .with('root_url/add_user', form: payload)
        .and_return(response)
      client.add_user(payload)
    end
  end

  describe '#add_permission' do
    let(:url) { 'root_url' }
    let(:payload) { 'payload' }
    let(:client) { described_class.new(url) }

    it 'calls add permission api' do
      expect(HTTP).to receive(:post)
        .with('root_url/add_permission', form: payload)
      client.add_permission(payload)
    end
  end

  describe '#reset' do
    let(:url) { 'root_url' }
    let(:client) { described_class.new(url) }

    it 'calls reset api' do
      expect(HTTP).to receive(:post)
        .with('root_url/reset')
      client.reset
    end
  end
end
