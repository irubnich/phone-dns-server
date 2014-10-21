require "./lib/phone_dns/resolver"

describe PhoneDNS::Resolver do
	before :each do
		@resolver = PhoneDNS::Resolver.new("example.com")
	end

	it "can resolve TXT records" do
		records = @resolver.send(:get_txt)
		expect(records[0].class).to eql Resolv::DNS::Resource::IN::TXT
		expect(records[0].strings[0]).to_not be_empty
	end

	it "can parse results" do
		allow(@resolver).to receive(:get_txt) do
			[Resolv::DNS::Resource::IN::TXT.new("phone-dns", "en_US=1112223333", "en_GB=1112223333", "mr=1112223333")]
		end
		expect(@resolver.parse).to eql ["en_US=1112223333", "en_GB=1112223333", "mr=1112223333"]
	end

	it "doesn't parse unrelated results" do
		allow(@resolver).to receive(:get_txt) do
			[Resolv::DNS::Resource::IN::TXT.new("phone-dns", "en_US=1112223333", "en_GB=1112223333", "mr=1112223333"),
			 Resolv::DNS::Resource::IN::TXT.new("some unrelated record", "and string 2")]
		end
		expect(@resolver.parse).to eql ["en_US=1112223333", "en_GB=1112223333", "mr=1112223333"]
	end

	it "handles there being no phone records" do
		allow(@resolver).to receive(:get_txt) do
			[Resolv::DNS::Resource::IN::TXT.new("some unrelated record", "and string 2")]
		end
		expect { @resolver.parse }.to raise_error(PhoneDNS::NoPhoneRecordException)
	end

	it "handles there being no records" do
		allow(@resolver).to receive(:get_txt) { [] }
		expect { @resolver.parse }.to raise_error(PhoneDNS::NoTXTRecordException)
	end
end
