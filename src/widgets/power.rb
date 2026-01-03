require "gtk4"
require_relative "../widgets"

# A simple power button
class Widgets::Power < Widgets::BaseWidget
    def initialize options
        options[:on_click] ||= proc { `notify-send 'imagine a shutdown'` }
        super
        @button = Gtk::Button.new label: ""
        append @button
    end
end
