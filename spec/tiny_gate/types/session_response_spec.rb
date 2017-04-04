require 'spec_helper'

describe TinyGate::Types::SessionResponse do
  describe '#success?' do
    let(:response) { double('Response', status: status, body: '{}') }
    let(:session_response) { described_class.new(response) }
    subject { session_response.success? }

    context 'when response status is 200' do
      let(:status) { 200 }
      it { is_expected.to eq true }
    end

    context 'when response status is not 200' do
      let(:status) { 400 }
      it { is_expected.to eq false }
    end
  end
end
