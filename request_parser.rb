require "./resolver"

# This class parses a Sinatra request
class RequestParser
	def initialize(domain, locale)
		@domain, @locale = domain, locale
	end

	def resolve_request
		resolver = Resolver.new(@domain)
		begin
			return resolver.parse
		rescue Exception => e
			raise e # todo, handle
		end
	end

	def get_number_for_locale
		numbers = resolve_request
		number_in_locale = numbers.select { |num| num[@locale] }
		if number_in_locale.empty?
			raise RequestParserExceptions::NoNumberForLocaleException
		end
		
		# Okay we know there is a number in the locale, just split it out now
		return number_in_locale[0].split('=')[1]
	end
end