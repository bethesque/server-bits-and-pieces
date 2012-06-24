require 'net/http'
require 'uri'
require 'net/smtp'
require 'config'
include ServerConfig

def send_email(from, from_alias, to, to_alias, subject, message)
	msg = <<END_OF_MESSAGE
From: #{from_alias} <#{from}>
To: #{to_alias} <#{to}>
Subject: #{subject}
Content-Type: text/plain; charset=ISO-8859-1


#{message}
END_OF_MESSAGE
	
	smtp = Net::SMTP.new(config.email.smtp.host, config.email.smtp.port)
        smtp.enable_starttls
	smtp.start(config.email.sender.domain, config.email.sender.address, config.email.sender.password, :login) do |smtp|
		smtp.send_message msg, from, to
	end
end
