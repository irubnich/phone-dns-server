module PhoneDNS
	class Logger
		def self.log(name, msg)
			puts "[#{Time.now}] [#{name}] #{msg}"
		end
	end
end
