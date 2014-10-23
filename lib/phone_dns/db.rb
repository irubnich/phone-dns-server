require 'mongo'

module PhoneDNS
	# PhoneDNS uses MongoDB as a fallback database to query
	class DB
		include Mongo

		def initialize
			client = MongoClient.new
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
