require "sinatra"
require "json"

require "./lib/phone_dns/logger"
require "./lib/phone_dns/request_parser"

get '/:domain/:locale' do |domain, locale|
	content_type :json

	# Serialize request
	phone_request = {
		domain: domain,
		locale: locale
	}

	# Invoke the request parser
	parser = PhoneDNS::RequestParser.new(phone_request)
	begin
		number = parser.get_number_for_locale
	rescue Exception => e
		return handle_error_response(phone_request, e)
	end

	# Log
	PhoneDNS::Logger.log("Router", "success for #{phone_request} / #{number}")

	status 200
	body({
		request: phone_request,
		response: {
			success: true,
			number: number
		}
	}.to_json)
end

def handle_error_response(request, exception)
	# Log
	PhoneDNS::Logger.log("Router", "failure for #{request}: #{exception.message}")

	status 404
	body({
		request: request,
		response: {
			success: false,
			error: exception.message
		}
	}.to_json)
end
