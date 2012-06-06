require 'email'
require 'base64'
require 'config'
require 'logger'


log = Logger.new("#{config.log.dir}/remember_the_milk.log",'monthly')
begin
  include ServerConfig

  #TODO use proper ruby lib for this
  text = ""
  stdin = ""
  until stdin == nil
    stdin = STDIN.gets
    text << stdin unless stdin.nil?
  end

  if text.include?("remind@rememberthemilk.com")
    encrypted_body = text.split("\n\n")[-1]
    body = Base64.decode64(encrypted_body)

    subject = ""
    i = 1
    while body.match(/^#{i}\.\s(.*)/)
      subject << ($1 + " ")
      i+=1
    end

    log.info "Sending email with subject '#{subject}'"
    send_email(config.email.sender.address, "Remember The Milk", config.email.beth.address, "Beth", subject, body)
  end
rescue StandardError => e
  log.error e
  raise e
end
