require "./lib/phone_dns/db"

task :build_db do
	@db = PhoneDNS::DB.new
	@collection = @db.instance_variable_get(:@collection)

	# Ensure indeces
	@collection.ensure_index({
		domain: 1,
		locale: 1
	}, {
		unique: true
	})
end
