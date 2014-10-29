require "./lib/phone_dns/db"

describe PhoneDNS::DB do
	before :all do
		@db = PhoneDNS::DB.new

		# Insert an entry
		@collection = @db.instance_variable_get(:@collection)
		@collection.insert({
			domain: 'example.com',
			locale: 'en_US',
			number: '5551112323'
		})
	end

	after :all do
		@collection.remove()
	end

	it "works with a result" do
		result = @db.find('example.com', 'en_US')
		expect(result["number"]).to eql "5551112323"
	end

	it "works without a result" do
		result = @db.find('example.com', 'nah')
		expect(result).to be_nil
	end

	it "can still insert multiple entries for a single domain" do
		expect {
			@collection.insert({
				domain: 'example.com',
				locale: 'en_UK',
				number: '5551231122'
			})
		}.to_not raise_error
	end

	it "has a unique index on the domain/locale" do
		expect {
			@collection.insert({
				domain: 'example.com',
				locale: 'en_US',
				number: '5551112323'
			})
		}.to raise_error(Mongo::OperationFailure)
	end
end
