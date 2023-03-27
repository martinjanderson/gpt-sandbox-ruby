# spec/spec_helper.rb
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app/album.rb', __FILE__)

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin
    config.before(:each) do
        # Mock the Authorization header to simulate a valid access token
        header 'Authorization', "Bearer mock_token"  

        # Skip authentication for this endpoint
        allow_any_instance_of(Object).to receive(:authenticate_user).and_return('test@martinanderson.dev')  
    end

    config.after(:each) do
        
    end
end

