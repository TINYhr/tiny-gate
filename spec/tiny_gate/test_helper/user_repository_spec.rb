require 'spec_helper'

describe TinyGate::TestHelper::UserRepository do
  let(:repo) { described_class }

  before do
    repo.reset
  end

  describe '.add_user' do
    let(:id) { 1 }
    let(:email) { 'email' }
    let(:password) { 'password' }

    it 'adds user' do
      new_user = repo.add_user(id: id, email: email, password: password)
      expect(new_user.id).to eq id
      expect(new_user.email).to eq email
      expect(new_user.password).to eq password
      expect(repo.users.any? { |user| user == new_user }).to eq true
    end
  end

  describe '.find_by_email' do
    let(:email) { 'email' }
    subject { repo.find_by_email(email) }

    context 'when user exists' do
      let(:id) { 'id' }
      let(:password) { 'password' }

      before do
        @new_user = repo.add_user(id: id, email: email, password: password)
      end

      it { is_expected.to eq @new_user }
    end

    context 'when user does not exist' do
      let(:id) { 'id' }
      let(:password) { 'password' }

      before do
        repo.add_user(id: id, email: 'other email', password: password)
      end

      it { is_expected.to eq nil }
    end
  end

  describe '.find_by_id' do
    let(:id) { 'id' }
    subject { repo.find_by_id(id) }

    context 'when user exists' do
      let(:email) { 'email' }
      let(:password) { 'password' }

      before do
        @new_user = repo.add_user(id: id, email: email, password: password)
      end

      it { is_expected.to eq @new_user }
    end

    context 'when user does not exist' do
      let(:email) { 'email' }
      let(:password) { 'password' }

      before do
        repo.add_user(id: 'other id', email: email, password: password)
      end

      it { is_expected.to eq nil }
    end
  end

  describe '.find_by_token' do
    let(:id) { 'id' }
    let(:email) { 'email' }
    let(:password) { 'password' }
    subject { repo.find_by_token(token) }

    before do
      @new_user = repo.add_user(id: id, email: email, password: password)
      @token = @new_user.token
    end

    context 'when user exists' do
      let(:token) { @token }
      it { is_expected.to eq @new_user }
    end

    context 'when user does not exist' do
      let(:token) { 'no token' }
      it { is_expected.to eq nil }
    end
  end
end
