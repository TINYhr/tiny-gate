require 'spec_helper'

describe TinyGate::TestHelper::SessionsController do
  def app
    described_class
  end

  before do
    TinyGate::TestHelper::UserRepository.reset
  end

  describe 'POST /signout' do
    it 'runs successfully' do
      post '/signout'
      expect(last_response).to be_ok
    end
  end

  describe 'GET /auth/sessions/new' do
    it 'runs successfully' do
      get '/auth/sessions/new'
      expect(last_response).to be_ok
    end
  end

  describe 'POST /auth/sessions' do
    let(:email) { 'email' }
    let(:password) { 'password' }
    let(:params) do
      {
        session: {
          email: email,
          password: password
        }
      }
    end

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

  describe 'POST /auth/sessions/validate' do
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
        post '/auth/sessions/validate', params, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq 200
      end
    end

    context 'when user token is not valid' do
      let(:params) { { ticket: 'invalid token' }.to_json }

      it 'returns error' do
        post '/auth/sessions/validate', params, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq 401
        expect(last_response.body).to   eq({ errors: 'Invalid Token' }.to_json)
      end
    end
  end

  describe 'POST /auth/sessions/signed_in' do
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
      let(:params) { { user_id: user_id, token: 'Invalid Token' }.to_json }

      it 'returns error' do
        post '/auth/sessions/signed_in', params, {'CONTENT_TYPE' => 'application/json'}
        expect(last_response.status).to eq 401
        expect(last_response.body).to   eq 'Invalid Token'
      end
    end
  end
end
