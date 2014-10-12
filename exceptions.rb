module ResolverExceptions
	class NoTXTRecordException < Exception
		def initialize(msg = "No TXT records exist for this domain.")
			super
		end
	end

	class NoPhoneRecordException < Exception
		def initialize(msg = "No phone records exist for this domain.")
			super
		end
	end
end

module RequestParserExceptions
	class NoNumberForLocaleException < Exception
		def initialize(msg = "No phone number exists for this locale.")
			super
		end
	end
end
