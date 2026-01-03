require "gtk4"
require_relative "../widgets"

# Volume control via PulseAudio
# 
# The instance variables @volume @display_volume and @muted are exposed
# 
class Widgets::Volume < Widgets::BaseWidget
    def initialize options
        options[:on_click] ||= proc { toggle_mute }
        super
        @label = Gtk::Label.new ''
        get_default_sink_volume
        update_safe
        listen_thread
        append @label
    end
    
    def update
      @display_volume = (@volume * 100).round
      @label.set_text(instance_exec(&@proc) || "#{self.class.speaker_emoji(@volume, muted: @muted)} #{@display_volume || '?'}")
    end
    
    # https://www.unicode.org/charts/PDF/U1F300.pdf
    def self.speaker_emoji(volume = Float, muted: Boolean | false) -> { String }
      return "🔇" if muted
      case volume
      when 0.0...0.2 then "🔈"
      when 0.2...0.5 then "🔉"
      when 0.5...1.0 then "🔊"
      else
        raise "unexpected volume #{volume}"
      end
    end
    
    def toggle_mute
      `wpctl set-mute @DEFAULT_SINK@ toggle`
    end
    
    private
    def listen_thread
      Thread.new {
        IO.popen("pactl subscribe") { |io|
          io.each_line do |line|
            p line
            case line.chomp
            when /^Event 'change' on sink #(\d+)$/
              sink_id = $1.to_i
              get_default_sink_volume
              update_safe
            end
          end
        }
      }
    end
    
    def get_default_sink_volume
      # annoying to combine pulseaudio and pipewire commands
      # but wpctl also shows if the sink is muted
      out = `wpctl get-volume @DEFAULT_AUDIO_SINK@`
      out =~ /Volume: (?<vol>[\d.]+)(?<mute> \[MUTED\])?/ or raise "failed to get volume"
      @volume = $~[:vol].to_f
      @muted = !$~[:mute].nil?

      # alternative is pactl get-sink-volume @DEFAULT_SINK@
    end
end
