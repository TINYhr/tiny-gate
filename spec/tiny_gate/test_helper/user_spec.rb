require 'spec_helper'

describe TinyGate::TestHelper::User do
  describe '#add_permission' do
    let(:id) { 'id' }
    let(:email) { 'email' }
    let(:password) { 'password' }
    let(:user) { described_class.new(id, email, password) }
    let(:permission_id) { 1 }
    let(:role_id) { 2 }
    let(:role_name) { 'admin' }
    let(:organization_id) { 3 }

    it 'creates new permission' do
      permissions = user.add_permission(permission_id, role_id, role_name, organization_id)
      last_permission = permissions.first
      expect(last_permission.id).to eq permission_id
      expect(last_permission.role_id).to eq role_id
      expect(last_permission.organization_id).to eq organization_id
    end
  end

  describe '#data' do
    let(:id) { 'id' }
    let(:email) { 'email' }
    let(:password) { 'password' }
    let(:user) { described_class.new(id, email, password) }
    let(:permission_id) { 1 }
    let(:role_id) { 2 }
    let(:role_name) { 'admin' }
    let(:organization_id) { 3 }
    let(:permission_data) do
      {
        id:                permission_id,
        app_id:            nil,
        user_id:           id,
        role_id:           role_id,
        role_name:         role_name,
        organization_id:   organization_id,
        organization_name: nil
      }
    end
    let(:data) do
      {
        id:                 id,
        email:              email,
        token:              user.token,
        first_name:         'First',
        last_name:          'Last',
        current_permission: nil,
        active_permissions: [permission_data]
      }
    end
    subject { user.data }

    before do
      user.add_permission(permission_id, role_id, role_name, organization_id)
    end

    it { is_expected.to eq data }
  end
end
