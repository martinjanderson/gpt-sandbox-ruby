# spec/spec_helper.rb
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app/album.rb', __FILE__)

module RSpecMixin
  include Rack::Test::Methods
  def app() AlbumApp end
end

RSpec.configure do |config|
  config.include RSpecMixin
    config.before(:each) do |example|
        
        # Skip before filter if metadata is set
        next if example.metadata[:skip_global_before]

        # Mock the Authorization header to simulate a valid access token
        header 'Authorization', "Bearer mock_token"  

        # Skip authentication for this endpoint
        allow_any_instance_of(AlbumApp).to receive(:authenticate_user).and_return('test@example.com')  
    end

    config.after(:each) do
        
    end
end

