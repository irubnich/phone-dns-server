require './router'
require 'rack/test'
require 'pry'

describe 'main API endpoint' do
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	before :all do
		# Insert an entry
		db = PhoneDNS::DB.new
		@collection = db.instance_variable_get(:@collection)
		@collection.insert({
			domain: 'example.com',
			locale: 'en_US',
			number: '5551112323'
		})
	end

	after :all do
		@collection.remove()
	end

	it "gives a proper success response" do
		get '/example.com/en_US'
		expect(last_response.status).to eql 200
		expect(last_response.header["Content-Type"]).to eql "application/json"

		body_hash = JSON.parse(last_response.body)
		expect(body_hash["request"]["domain"]).to eql "example.com"
		expect(body_hash["request"]["locale"]).to eql "en_US"
		expect(body_hash["response"]["success"]).to eql true
		expect(body_hash["response"]["number"]).to eql "5551112323"
	end

	it "gives a proper error response" do
		get '/example.com/en_UK'
		expect(last_response.status).to eql 404
		expect(last_response.header["Content-Type"]).to eql "application/json"

		body_hash = JSON.parse(last_response.body)
		expect(body_hash["request"]["domain"]).to eql "example.com"
		expect(body_hash["request"]["locale"]).to eql "en_UK"
		expect(body_hash["response"]["success"]).to eql false
		expect(body_hash["response"]["error"]).to match(/No phone number/)
	end
end
