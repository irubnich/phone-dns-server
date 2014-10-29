require "./lib/phone_dns/resolver"
require "./lib/phone_dns/db"

# This class parses a Sinatra request
module PhoneDNS
	class RequestParser
		def initialize(request)
			@domain, @locale = request[:domain], request[:locale]
		end

		# DNS
		def resolve_request
			resolver = PhoneDNS::Resolver.new(@domain)

			# Attmpt to resolve the given request via DNS
			begin
				return resolver.parse
			rescue PhoneDNS::NoTXTRecordException => e
				# This means we can fallback to DB
			rescue PhoneDNS::NoPhoneRecordException => e
				# This means we can fallback to DB
			end

			# We'd have raised any other exceptions by now
			return []
		end

		# DB
		# Here we can actually make an efficient query with both the domain and locale at the same time
		def query_request
			db = PhoneDNS::DB.new
			return db.find(@domain, @locale)
		end

		def get_number_for_locale
			# Try DNS
			numbers = resolve_request
			number_in_locale = numbers.select { |num| num[@locale] }

			if number_in_locale.empty?
				# Fallback quietly to a DB query
			else
				# Okay we know there is a number with this locale, just split it out now
				return {
					number: number_in_locale[0].split('=')[1],
					source: "DNS"
				}
			end

			# Try DB
			number_in_locale = query_request

			if number_in_locale.nil?
				# At this point, we have exhausted our options, so raise an exception.
				raise PhoneDNS::NoNumberForLocaleException
			end

			return {
				number: number_in_locale["number"],
				source: "DB"
			}
		end
	end
end
