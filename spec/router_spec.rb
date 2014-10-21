require './router'
require 'rack/test'

describe 'main API endpoint' do
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	it "gives a proper error response" do
		get '/example.com/en_US'
		expect(last_response.status).to eql 404
		expect(last_response.header["Content-Type"]).to eql "application/json"

		body_hash = JSON.parse(last_response.body)
		expect(body_hash["request"]["domain"]).to eql "example.com"
		expect(body_hash["request"]["locale"]).to eql "en_US"
		expect(body_hash["response"]["success"]).to eql false
		expect(body_hash["response"]["error"]).to match(/No phone records/)
	end
end
