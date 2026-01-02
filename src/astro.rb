require "astronoby"
require "low_type"
require_relative "dirs"

module RubyBar # :nodoc:
  class Astro # :nodoc:
    include LowType
    include Singleton

    def initialize
      download
      load
    end
    
    def moon_phase() -> { Float }
      Astronoby::Moon.new(ephem: @ephem, instant: Astronoby::Instant.from_time(Time.now)).current_phase_fraction
    end
  
    private
    def download
      if ! File.exist? "tmp/de421.bsp"
        warn "astro: downloading ephemeride"
        Astronoby::Ephem.download(name: "de421.bsp", target: "#{RubyBar::Dirs.tmp}/de421.bsp")
        warn "astro: finished downloading ephemride"
      end
    end
    
    def load
      @ephem = Astronoby::Ephem.load("#{RubyBar::Dirs.tmp}/de421.bsp")
    end

  end
end
