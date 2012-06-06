require 'open-uri'
require "email"
require 'config'
include ServerConfig

size10s = open("http://www.corsets-au.com/fashion/a3043-polka-dot.html") { | file | file.read.match(/"AU 8.*?"/)[0] rescue 'None'}
send_email(config.email.sender.address, "Corset watcher", config.email.shopping.address, "Beth", size10s, nil)

