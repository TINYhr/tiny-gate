require 'spec_helper'

describe TinyGate::Client do
  describe '#login_url' do
    let(:root_url) { 'root_url' }
    let(:app_id) { 1 }
    let(:url) { 'root_url/auth/sessions/new?app_id=1' }
    subject { client.login_url }

    context 'default' do
      let(:client) { described_class.new(root_url, app_id) }
      it { is_expected.to eq url }
    end

    context 'with callback url' do
      let(:callback_token) { 'abxzyx' }
      let(:client) { described_class.new(root_url, app_id, callback_token) }
      it { is_expected.to eq 'root_url/auth/sessions/new?app_id=1&callback_token=abxzyx' }
    end
  end

  describe '#logout_url' do
    let(:url) { 'root_url/signout' }
    let(:root_url) { 'root_url' }
    let(:app_id) { 1 }
    let(:client) { described_class.new(root_url, app_id) }
    subject { client.logout_url }
    it { is_expected.to eq url }
  end


  describe '#validate', integration: true do
    let(:root_url) { 'http://localhost:31338' }
    let(:app_id) { 4 }
    let(:client) { described_class.new(root_url, app_id) }

    context 'when user is valid' do
      let(:user_id) { 1 }
      let(:email) { 'dev@tinypulse.com' }
      let(:ticket) { 'ticket' }

      before do
        test_client = TinyGate::TestHelper::UserClient.new
        @token = test_client.add_user(id: user_id, email: email)
        test_client.add_permission(
          user_id: user_id,
          permission_id: 1,
          organization_id: 1,
          app_id: app_id
        )
      end

      it 'returns valid response' do
        result = client.validate(ticket: @token)
        expect(result).to be_success
        expect(result.global_user.email).to eq email
        expect(result.global_user.token).not_to be_nil
      end
    end

    context 'when user is not valid' do
      it 'returns invalid response' do
        result = client.validate(ticket: 'invalid ticket')
        expect(result).not_to be_success
      end
    end
  end

  describe '#signed_in?', integration: true do
    let(:root_url) { 'http://localhost:31338' }
    let(:app_id) { 3 }
    let(:client) { described_class.new(root_url, app_id) }

    context 'when token is valid' do
      let(:user_id) { 1 }

      before do
        test_client = TinyGate::TestHelper::UserClient.new
        @token = test_client.add_user(id: user_id)
      end

      it 'returns signed in' do
        expect(client).to be_signed_in(@token, user_id)
      end
    end

    context 'when token is not valid' do
      let(:token) { 'invalid' }
      let(:user_id) { 2 }

      it 'returns not signed in' do
        expect(client).not_to be_signed_in(token, user_id)
      end
    end
  end

  describe '#fetch_user', integration: true do
    let(:root_url) { 'http://localhost:31338' }
    let(:app_id) { 4 }
    let(:client) { described_class.new(root_url, app_id) }

    context 'when token is valid' do
      let(:user_id) { 1 }

      before do
        test_client = TinyGate::TestHelper::UserClient.new
        @token = test_client.add_user(id: user_id)
        test_client.add_permission(
          user_id: user_id,
          permission_id: 1,
          organization_id: 1,
          app_id: app_id
        )
      end

      it 'fetches user successfully' do
        response = client.fetch_user(@token, user_id)
        expect(response).to be_success
        expect(response.global_user).not_to be_nil
      end
    end

    context 'when token is not valid' do
      let(:token) { 'invalid' }
      let(:user_id) { 2 }

      it 'fetches user unsuccessfully' do
        response = client.fetch_user(token, user_id)
        expect(response).not_to be_success
      end
    end
  end

  describe '#switch_org', integration: true do
    let(:root_url) { 'http://localhost:31338' }
    let(:app_id) { 4 }
    let(:organization_id) { 11 }
    let(:user_id) { 1 }
    let(:client) { described_class.new(root_url, app_id) }

    before do
      test_client = TinyGate::TestHelper::UserClient.new
      @token = test_client.add_user(id: user_id)
    end

    it 'returns new token url' do
      new_token_url = client.switch_org(@token, organization_id, user_id)
      expect(new_token_url).not_to be_empty
    end
  end
end
