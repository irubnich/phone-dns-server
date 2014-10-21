require "./lib/resolver"

# This class parses a Sinatra request
module PhoneDNS
	class RequestParser
		def initialize(request)
			@domain, @locale = request[:domain], request[:locale]
		end

		def resolve_request
			resolver = PhoneDNS::Resolver.new(@domain)
			return resolver.parse
		end

		def get_number_for_locale
			numbers = resolve_request
			number_in_locale = numbers.select { |num| num[@locale] }
			if number_in_locale.empty?
				raise PhoneDNS::NoNumberForLocaleException
			end

			# Okay we know there is a number in the locale, just split it out now
			return number_in_locale[0].split('=')[1]
		end
	end
end
