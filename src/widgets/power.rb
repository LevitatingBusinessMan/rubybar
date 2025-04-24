require "gtk4"
require_relative "../widgets"

# A custom widget that executs a proc
class Widgets::Power < Widgets::Widget
    def initialize options
        super
        @button = Gtk::Button.new label: ""
        append @button

        @button.signal_connect("clicked") { `notify-send 'imagine a shutdown'` }
    end
end
