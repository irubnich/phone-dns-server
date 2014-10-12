require "sinatra"
require "json"

require "./request_parser"

get '/:domain/:locale' do |domain, locale|
	# Invoke the request parser
	parser = RequestParser.new(domain, locale)
	begin
		number = parser.get_number_for_locale
	rescue Exception => e
		raise e # todo: handle
	end

	return {
		request: {
			domain: domain,
			locale: locale
		},
		response: number
	}.to_json
end
