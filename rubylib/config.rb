#http://mjijackson.com/2010/02/flexible-ruby-config-objects

class Conf

  def initialize(data={})
    @data = {}
    update!(data)
  end

  def update!(data)
    data.each do |key, value|
      self[key] = value
    end
  end

  def [](key)
    @data[key.to_sym]
  end

  def []=(key, value)
    if value.class == Hash
      @data[key.to_sym] = Conf.new(value)
    else
      @data[key.to_sym] = value
    end
  end

  def method_missing(sym, *args)
    if sym.to_s =~ /(.+)=$/
      self[$1] = args.first
    else
      self[sym]
    end
  end

end

require 'yaml'
module ServerConfig  
  def config
    @conf ||= Conf.new(YAML.load_file("#{ENV['HOME']}/conf/config.yaml"))
    @conf
  end
end
