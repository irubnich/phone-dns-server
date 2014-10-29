require "./lib/phone_dns/request_parser"

describe PhoneDNS::RequestParser do
	describe "with DNS" do
		before :each do
			sample_request = {
				:domain => "example.com",
				:locale => "en_US"
			}
			@parser = PhoneDNS::RequestParser.new(sample_request)
			allow(@parser).to receive(:resolve_request) do
				["en_US=1112223333", "en_GB=1235551212", "mr=3215550909"]
			end
		end

		it "gets a number given a present locale" do
			expect(@parser.get_number_for_locale[:number]).to eql "1112223333"
		end

		# Sanity check
		it "gets a number given a non-US locale" do
			@parser.instance_variable_set(:@locale, "mr")
			expect(@parser.get_number_for_locale[:number]).to eql "3215550909"
		end

		it "gives an error given a non-present locale" do
			@parser.instance_variable_set(:@locale, "no_PE")
			expect { @parser.get_number_for_locale }.to raise_error(PhoneDNS::NoNumberForLocaleException)
		end
	end

	describe "with the DB fallback" do
		before :all do
			# Insert an entry
			db = PhoneDNS::DB.new
			@collection = db.instance_variable_get(:@collection)
			@collection.insert({
				domain: 'example.com',
				locale: 'en_US',
				number: '5551112323'
			})
		end

		after :all do
			@collection.remove()
		end

		before :each do
			sample_request = {
				:domain => "example.com",
				:locale => "en_US"
			}
			@parser = PhoneDNS::RequestParser.new(sample_request)

			# Force the DNS resolver to return nothing
			allow(@parser).to receive(:resolve_request) { [] }
		end

		it "works with an entry in the db" do
			expect(@parser.get_number_for_locale[:number]).to eql "5551112323"
		end

		it "does not work with no entry in the db" do
			@parser.instance_variable_set(:@locale, "no_PE")
			expect { @parser.get_number_for_locale }.to raise_error(PhoneDNS::NoNumberForLocaleException)
		end

		# Sanity check
		describe "with a non-US locale" do
			before :all do
				# Insert an entry
				@collection.insert({
					domain: 'example.com',
					locale: 'en_UK',
					number: '6661112323'
				})
			end

			after :all do
				@collection.remove()
			end

			it "works with a non-US entry in the DB" do
				@parser.instance_variable_set(:@locale, "en_UK")
				expect(@parser.get_number_for_locale[:number]).to eql "6661112323"
			end

			it "does not work when there is no number for a non-US entry in the DB" do
				@parser.instance_variable_set(:@locale, "en_CA")
				expect { @parser.get_number_for_locale }.to raise_error(PhoneDNS::NoNumberForLocaleException)
			end
		end
	end
end
