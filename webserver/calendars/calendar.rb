$: << ENV['LIBPATH']
require "net/http" 
require "uri"
require "date"
require 'action_view'
require 'convert_time_zone'

class DateHelper
  include ActionView::Helpers::DateHelper
end

module Calendar
  def retrieve_calendar host, path
    url = URI.parse(host)
    req = Net::HTTP::Get.new(url.path + path)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    output = res.body
    output.gsub!("CLASS:PRIVATE","CLASS:PUBLIC")
    #output.gsub!(/(DTSTART\:\d{8})(\D)/) {"#{$1}T090000Z#{$2}"}
    random_string = "ksnfri3y4ounxjhi2385944jdfnkuw4974kijgfjso1ncdj"
    output.gsub!("BEGIN:VEVENT", random_string+"BEGIN:VEVENT")
    events = output.split(random_string)
    header = events.delete_at(0)
    events[-1] = events[-1].gsub(/\r?\nEND:VCALENDAR/,"")
    return header, events, "END:VCALENDAR"
  end
  
  def download_time
    aus_time = Time.now.convert_time_zone("Australia/Melbourne")
    aus_time.strftime('(%a %I').gsub(/0(\d)/){$1} + aus_time.strftime('%p)').downcase
  end
  
  def summary(event)
    event.match(/SUMMARY\:(.*)/)[1]
  end
  
  def start_time_string(event)
    event.match(/DTSTART\:(\S+)/)[1] rescue nil
  end
  
  def end_time_string(event)
    event.match(/DTEND\:(\S+)/)[1] rescue nil
  end
  
  def to_date_time(date_string)
    if date_string =~ /\d{8}T\d{6}Z/
        DateTime.strptime(date_string, "%Y%m%dT%H%M")    
    elsif date_string =~ /\d{8}/
        DateTime.strptime(date_string, "%Y%m%d")            
    else
       nil    
    end
  end
  
  def start_time(event)
    date_string = start_time_string(event)
    to_date_time(date_string)
  end

  def end_time(event)
    date_string = end_time_string(event)
    to_date_time(date_string)
  end


end
