require "./lib/exceptions"
require "resolv"

# This takes care of the DNS resolution and parsing of a request
module PhoneDNS
	class Resolver
		IDENTIFIER = "phone-dns"

		def initialize(domain)
			@domain = domain
		end

		def parse
			records = get_txt

			# Exit here if there are no TXT records
			if records.empty?
				raise PhoneDNS::NoTXTRecordException.new
			end

			# Get the record that starts with the identifier
			records.select! { |record| record.strings[0] == IDENTIFIER }

			# Exit here if there is no such record
			if records.empty?
				raise PhoneDNS::NoPhoneRecordException.new
			end

			# Remove the identifier
			records = records[0].strings
			records.delete_at(0)

			# Return a plain array of format:
			# ["locale1=1231231212", "locale2=3475551234"]
			return records
		end

		private
			# Seems to just return an empty array
			# when given an invalid domain, so less validation!
			#
			# But, I think it's necessary to check the bare domain
			# if something like "www." is given
			# Or fallback to not-www
			def get_txt
				Resolv::DNS.open do |dns|
					return dns.getresources(@domain, Resolv::DNS::Resource::IN::TXT)
				end
			end
	end
end
