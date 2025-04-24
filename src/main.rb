require "gtk4_layer_shell/preload"
require "gtk4"
require "optparse"
require "xdg"
require_relative "dsl"

args = {}
OptionParser.new do |parser|
  parser.banner = "Usage: rubybar [options]"

  parser.on("-v", "--[no-]verbose", "Show debugging info") do |verbose|
    args[:verbose] = verbose
  end

  parser.on("--debug", "Use the interactive GTK debugger") do |debug|
    args[:debug] = debug
  end

  parser.on("-cFILE", "--config=FILE", "Config file") do |config|
    args[:config] = config
  end
end.parse!

xdg = XDG.new

config_path = if args.include? :config
  args[:config]
  elsif File.exist? "#{xdg.config_home}/rubybar.rb"
    "#{xdg.config_home}/rubybar.rb"
  elsif File.exist? "#{xdg.config_home}/rubybar/config.rb"
    "#{xdg.config_home}/rubybar/config.rb"
  else
    nil
end


puts "Config: #{config_path.inspect}"
dsl = DSL.new config_path
options = dsl.options.dup

if args[:verbose]
  puts "Arguments:"
  pp args
  puts "DSL options:"
  pp options
  options[:verbose] = true
end

if args[:debug]
  ENV["GTK_DEBUG"] = "interactive"
end

require_relative "app"
require_relative "bar"

app = App.new options

app.signal_connect :activate do |app|
  bar = Bar.new app
  bar.show
end

app.run  
