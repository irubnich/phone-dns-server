module ResolverExceptions
	class NoTXTRecordException < Exception; end
	class NoPhoneRecordException < Exception; end
end

module RequestParserExceptions
	class NoNumberForLocaleException < Exception; end
end
