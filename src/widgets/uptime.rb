require "gtk4"
require_relative "../widgets"

class Widgets::Uptime < Widgets::Widget
    def initialize
        super
        @label = Gtk::Label.new @str
        append @label
    end
    def update
        @str = `uptime`
    end
end
