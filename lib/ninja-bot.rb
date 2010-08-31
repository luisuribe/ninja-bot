gem 'cinch', '1.0.1'
require 'cinch'
require 'nokogiri'
require 'httparty'
require 'timeout'

require 'core_ext'

class NinjaBot < Cinch::Bot
  def initialize(config)
    super()

    config.each do |k, v|
      self.config.send("#{k}=", v)
    end

   load_plugins
  end

  protected
  def shorten_url(url)
    open("http://bit.ly/api?url=#{url}").read rescue nil
  end

  def safe_run(bot, &block)
    begin
      block.call(bot, *args)
    rescue Exception => e
      bot.reply "#{e.message} -- #{e.backtrace[0,5].join(", ")}"
    end
  end

  private
  def load_plugins
    puts "*"*80
    Dir["./plugins/*.rb"].each do |file|
      puts "loading #{file}..."
      begin
        eval File.read(file)
      rescue Exception => e
        puts "Cannot load: #{e.inspect}"
      end
    end
    puts "*"*80
  end
end
