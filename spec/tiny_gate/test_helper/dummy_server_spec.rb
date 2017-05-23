require 'spec_helper'
require 'rack/test'
require 'tiny_gate/test_helper/dummy_server'

ENV['RACK_ENV'] = 'test'

describe TinyGate::TestHelper::DummyServer do
  include Rack::Test::Methods

  def app
    described_class
  end

  before do
    TinyGate::TestHelper::UserRepository.reset
  end

  describe 'post /signout' do
    it 'runs successfully' do
      post '/signout'
      expect(last_response).to be_ok
    end
  end

  describe 'get /auth/sessions/new' do
    it 'runs successfully' do
      get '/auth/sessions/new'
      expect(last_response).to be_ok
    end
  end

  describe 'post /auth/sessions' do
    let(:email) { 'email' }
    let(:password) { 'password' }
    let(:params) { {
      session: {
        email: email,
        password: password
      }
    } }

    context 'when user does not exist' do
      it 'returns error' do
        post '/auth/sessions', params
        expect(last_response.body).to eq "There is no user with email #{email} and password: #{password}"
      end
    end

    context 'when user exists' do
      before do
        @user = TinyGate::TestHelper::UserRepository.add_user(id: 1, email: email, password: password)
      end

      it 'redirects to callback url' do
        post '/auth/sessions', params
        expect(last_response.status).to eq 302
      end
    end
  end

  describe 'post /auth/sessions/validate' do
    let(:user_id) { 1 }
    let(:email) { 'email' }
    let(:password) { 'password' }

    before do
        @user = TinyGate::TestHelper::UserRepository.add_user(
          id: user_id,
          email: email,
          password: password
        )
    end

    context 'when user token is valid' do
      let(:params) { { ticket: @user.token }.to_json }

      it 'returns success' do
        post '/auth/sessions/validate', params, {'CONTENT_TYPE' => 'application/json'}
        expect(last_response.status).to eq 200
      end
    end

    context 'when user token is not valid' do
      let(:params) { { ticket: 'invalid token' }.to_json }

      it 'returns error' do
        post '/auth/sessions/validate', params, {'CONTENT_TYPE' => 'application/json'}
        expect(last_response.status).to eq 401
        expect(last_response.body).to eq "{\"errors\": \"Invalid Token\"}"
      end
    end
  end

  describe 'post /auth/sessions/signed_in' do
    let(:user_id) { 1 }
    let(:email) { 'email' }
    let(:password) { 'password' }

    before do
        @user = TinyGate::TestHelper::UserRepository.add_user(
          id: user_id,
          email: email,
          password: password
        )
    end

    context 'when user token is valid' do
      let(:params) { { user_id: user_id, token: @user.token }.to_json }

      it 'returns success' do
        post '/auth/sessions/signed_in', params, {'CONTENT_TYPE' => 'application/json'}
        expect(last_response.status).to eq 200
      end
    end

    context 'when user token is not valid' do
      let(:params) { { user_id: user_id, token: 'invalid token' }.to_json }

      it 'returns error' do
        post '/auth/sessions/signed_in', params, {'CONTENT_TYPE' => 'application/json'}
        expect(last_response.status).to eq 401
        expect(last_response.body).to eq 'Invalid token'
      end
    end
  end
end
