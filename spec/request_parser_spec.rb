require "./lib/phone_dns/request_parser"

describe PhoneDNS::RequestParser do
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
		expect(@parser.get_number_for_locale).to eql "1112223333"
	end

	# Sanity check
	it "gets a number given a non-US locale" do
		@parser.instance_variable_set(:@locale, "mr")
		expect(@parser.get_number_for_locale).to eql "3215550909"
	end

	it "gives an error given a non-present locale" do
		@parser.instance_variable_set(:@locale, "no_PE")
		expect { @parser.get_number_for_locale }.to raise_error(PhoneDNS::NoNumberForLocaleException)
	end
end
