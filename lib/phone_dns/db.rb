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
				db_name = URI.parse(ENV['MONGOHQ_URL']).path.gsub(/^\//, '')
			else
				client = MongoClient.new
			end

			db = (db_name) ? client[db_name] : client['phone_dns']
			@collection = db['phone_numbers']
		end

		def find(domain, locale)
			# Query
			result = @collection.find_one({
				domain: domain,
				locale: locale
			})

			return result
		end
	end
end
