require './router'
require 'rack/test'
require 'pry'

describe 'main API endpoint' do
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	before :each do
		@parser = PhoneDNS::RequestParser.new({
			:domain => "example.com",
			:locale => "en_US"
		})
	end

	it "gives a proper success response" do
		allow(@parser).to receive(:resolve_request) do
			["en_US=1112223333", "en_GB=1235551212", "mr=3215550909"]
		end
		# todo
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
