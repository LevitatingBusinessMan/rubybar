require "gtk4"
require_relative "../widgets"

# A time widget.  
# [format:]
#    Takes a Time#strftime format string.
#    See {Formats for Dates and times}[https://docs.ruby-lang.org/en/master/strftime_formatting_rdoc.html].
#    Default is +%H:%M:%S+.
class Widgets::Time < Widgets::BaseWidget
    def initialize options
        options[:interval] ||= 1
        super
        @options[:format] ||= '%H:%M:%S'
        @label = Gtk::Label.new ''
        init_timer
        append @label
    end
    def update
        @label.set_text Time.now.strftime(@options[:format])
        set_tooltip_text Time.now.to_s
    end
end
