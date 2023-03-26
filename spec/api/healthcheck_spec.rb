# spec/api/healthcheck_spec.rb
require './spec/spec_helper'

describe 'Healthcheck Endpoint' do
  it 'returns ok' do
    get '/healthcheck'
    expect(last_response).to be_ok
  end
end
