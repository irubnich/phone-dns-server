require "./lib/phone_dns/db"

describe PhoneDNS::DB do
	before :each do
		@db = PhoneDNS::DB.new

		# Insert an entry
		@collection = @db.instance_variable_get(:@collection)
		@collection.insert({
			domain: 'example.com',
			locale: 'en_US',
			number: '5551112323'
		})
	end

	it "works with a result" do
		result = @db.find('example.com', 'en_US')
		expect(result["number"]).to eql "5551112323"
	end

	it "works without a result" do
		result = @db.find('example.com', 'nah')
		expect(result).to be_nil
	end
end
