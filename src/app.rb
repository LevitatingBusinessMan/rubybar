require "gtk4"

# The GTK Application
class App < Gtk::Application
  attr_reader :options

  def initialize options
    super "levitating.rubybar"
    @options = options
    apply_css
  end

  private
  def apply_css
    provider = Gtk::CssProvider.new
    css_path = File.join(File.dirname(__FILE__), 'style.css')
    css = eval("\"#{File.read(css_path)}\"")
    puts "Using default CSS:", css if options[:verbose]
    provider.load_from_data css + options[:css]
    Gtk::StyleContext.add_provider_for_display(
      Gdk::Display.default,
      provider,
      Gtk::StyleProvider::PRIORITY_APPLICATION
    )
  end
end
