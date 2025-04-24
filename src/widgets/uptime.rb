require "gtk4"
require_relative "../widgets"

# A widget that executes `uptime`
class Widgets::Uptime < Widgets::Widget
    def initialize options
        super
        @label = Gtk::Label.new ''
        init_timer
        append @label
    end
    def update
        @label.set_text `uptime`.chomp
    end
end
