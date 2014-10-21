require './router'
require 'rack/test'

describe 'main API endpoint' do
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	it "works" do
		get '/'
	end
end
