require "gtk4"
require_relative "../widgets"
require_relative "../astro"

# https://www.unicode.org/charts/PDF/U1F300.pdf

# https://sources.debian.org/src/bsdgames/2.17-35/pom/pom.c

class Widgets::Moon < Widgets::BaseWidget
    def initialize options
        options[:interval] ||= 3600
        @astro = RubyBar::Astro.instance
        super
        @label = Gtk::Label.new '?🌚?'
        append @label
        init_timer
    end
    
    def update
      @phase = case @astro.moon_phase
      when 0...0.0625, 0.9375..1.0 then '🌑'
      when 0.0625...0.1875 then '🌒'
      when 0.1875...0.3125 then '🌓'
      when 0.3125...0.4375 then '🌔'
      when 0.4375...0.5625 then '🌕'
      when 0.5625...0.6875 then '🌖'
      when 0.6875...0.8125 then '🌗'
      when 0.8125...0.9375 then '🌘'
      end
      @label.set_text instance_eval(&@proc) || @phase
    end
end
