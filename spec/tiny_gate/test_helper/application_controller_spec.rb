require 'spec_helper'

describe TinyGate::TestHelper::ApplicationController do
  def app
    described_class
  end

  it 'responds with a welcome message' do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to   include('Welcome to Mock Server!')
  end
end
