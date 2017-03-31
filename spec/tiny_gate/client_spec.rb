require 'spec_helper'

describe TinyGate::Client do
  describe '#login_url' do
    let(:root_url) { 'root_url' }
    let(:app_id) { 1 }
    let(:client) { described_class.new(root_url, app_id) }
    let(:url) { 'root_url/auth/sessions/new?app_id=1' }
    subject { client.login_url }
    it { is_expected.to eq url }
  end

  describe '#logout_url' do
    let(:url) { 'root_url/signout' }
    let(:root_url) { 'root_url' }
    let(:app_id) { 1 }
    let(:client) { described_class.new(root_url, app_id) }
    subject { client.logout_url }
    it { is_expected.to eq url }
  end


  describe '#validate' do
    let(:root_url) { 'http://app.lvh.me:3200' }
    let(:app_id) { 3 }
    let(:client) { described_class.new(root_url, app_id) }

    context 'when user is valid' do
      let(:email) { 'hieu@tinypulse.com' }
      let(:payload) { { ticket: 'ticket' } }

      it 'returns valid response' do
        VCR.use_cassette('validate when user is valid return valid response') do
          result = client.validate(payload)
          expect(result).to be_success
          expect(result.global_user.email).to eq email
          expect(result.global_user.token).not_to be_nil
        end
      end
    end

    context 'when user is not valid' do
      let(:payload) { { ticket: 'invalid ticket' } }

      it 'returns invalid response' do
        VCR.use_cassette('validate when user is not valid return invalid response') do
          result = client.validate(payload)
          expect(result).not_to be_success
        end
      end
    end
  end

  describe '#signed_in?' do
    let(:root_url) { 'http://app.lvh.me:3200' }
    let(:app_id) { 3 }
    let(:client) { described_class.new(root_url, app_id) }

    context 'when token is valid' do
      let(:token) { 'valid' }
      let(:user_id) { 1 }

      it 'returns signed in' do
        VCR.use_cassette('signed in returns true if token is valid') do
          expect(client).to be_signed_in(token, user_id)
        end
      end
    end

    context 'when token is not valid' do
      let(:token) { 'invalid' }
      let(:user_id) { 2 }

      it 'returns not signed in' do
        VCR.use_cassette('signed in returns false if token is invalid') do
          expect(client).not_to be_signed_in(token, user_id)
        end
      end
    end
  end

  describe '#fetch_user' do
    let(:root_url) { 'http://app.lvh.me:3200' }
    let(:app_id) { 3 }
    let(:client) { described_class.new(root_url, app_id) }

    context 'when token is valid' do
      let(:token) { 'valid' }
      let(:user_id) { 1 }

      it 'fetches user successfully' do
        VCR.use_cassette('fetch user successfully if token is valid') do
          response = client.fetch_user(token, user_id)
          expect(response).to be_success
          expect(response.global_user).not_to be_nil
        end
      end
    end

    context 'when token is not valid' do
      let(:token) { 'invalid' }
      let(:user_id) { 2 }

      it 'fetches user unsuccessfully' do
        VCR.use_cassette('fetch user unsuccessfully if token is invalid') do
          response = client.fetch_user(token, user_id)
          expect(response).not_to be_success
        end
      end
    end
  end
end
