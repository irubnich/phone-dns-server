require 'mongo'
require 'uri'

module PhoneDNS
	# PhoneDNS uses MongoDB as a fallback database to query
	class DB
		include Mongo

		def initialize
			# Check for production info
			if ENV['MONGOHQ_URL']
				client = MongoClient.from_uri(ENV['MONGOHQ_URL'])
			else
				client = MongoClient.new
			end

			db = client['phone_dns']
			@collection = db['phone_numbers']
		end

		def find(domain, locale)
			# Query
			result = @collection.find({
				domain: domain,
				locale: locale
			}).limit(1)

			return result.to_a
		end
	end
end